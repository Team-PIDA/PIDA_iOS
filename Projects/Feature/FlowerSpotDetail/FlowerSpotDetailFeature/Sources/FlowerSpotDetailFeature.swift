//
//  FlowerSpotDetailFeature.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import Foundation
import Shared
import DesignKit
import ComposableArchitecture
import FlowerSpotDetailFeatureInterface
import FlowerSpotClient
import BloomingClient
import CacheClient

extension FlowerSpotDetailFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.cache) var cache

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      // MARK: - Toast
      case let .showToastView(message):
        state.toastMessage = message
        return .none

      case .onAppear:
        state.isNeedDrawPath = true
        return .none

      case .checkAuth:
        if UserDefaultsKeys.isLoggedIn == true {
          let streetName = state.flowerSpotData.streetName
          let id = state.flowerSpotData.id
          return .send(.presentToBlooming(id: id, streetName: streetName))
        } else {
          return .send(.showLoginAlert)
        }

      case let .setFlowerSpotData(flowerSpotData):
        state.flowerSpotData = flowerSpotData
        return .none

      case let .setBloomingStatus(bloomingStatus):
        state.bloomingStatus = bloomingStatus
        return .none

      case let .setDistance(distance):
        state.distance = distance
        return .none

      case let .setVerifyBloomingStatus(isVotedBlooming):
        state.isVotedBlooming = isVotedBlooming
        return .none

      case .alertCancelTapped:
        state.isShowLoginAlert = false
        return .none

      case .alertAcceptTapped:
        state.isShowLoginAlert = false
        return .send(.delegate(.presentToLogin(id: state.flowerSpotData.id)))

      case .dismiss:
        state.isNeedDeletePath = true
        return .send(.delegate(.dismiss))

      case let .presentToBlooming(id, streetName):
        return .send(.delegate(.presentToBlooming(id: id, streetName: streetName)))

      case .showLoginAlert:
        state.isShowLoginAlert = true
        return .none

      // MARK: - Navigation (PhotoGallery)

      case .pushToPhotoGallery:
        state.path.append(.photoGallery)
        return .none

      case .popFromPhotoGallery:
        state.path.removeLast()
        return .none

      // MARK: - Presentation (PhotoViewer)

      case let .presentPhotoViewer(index):
        state.photoViewer = .init(
          imageUrls: state.flowerSpotData.imageUrls,
          currentIndex: index
        )
        state.isPresentPhotoViewer = true
        return .none

      case .dismissPhotoViewer:
        state.isPresentPhotoViewer = false
        return .none

      case .cleanupPhotoViewer:
        state.photoViewer = nil
        return .none

      case .photoViewerPreviousTapped:
        guard var viewer = state.photoViewer else { return .none }
        if viewer.currentIndex > 0 {
          viewer.currentIndex -= 1
          state.photoViewer = viewer
        }
        return .none

      case .photoViewerNextTapped:
        guard var viewer = state.photoViewer else { return .none }
        if viewer.currentIndex < viewer.imageUrls.count - 1 {
          viewer.currentIndex += 1
          state.photoViewer = viewer
        }
        return .none

      case let .photoViewerScaleChanged(scale):
        guard var viewer = state.photoViewer else { return .none }
        viewer.scale = scale
        viewer.isUIHidden = scale > 1.0
        state.photoViewer = viewer
        return .none

      // MARK: - Image Prefetch

      case .prefetchImages:
        let urls = state.flowerSpotData.imageUrls
        guard !urls.isEmpty else { return .none }
        return prefetchImages(urls: urls)

      case let .imagesPrefetched(images):
        state.prefetchedImages = images
        return .none

      case let .cacheImage(url, data):
        // State에 추가
        state.prefetchedImages[url] = data
        // 캐시에 저장 (백그라운드)
        return .run { [cache] _ in
          try? await cache.set(.remoteImage(url: url), data)
        }

      case let .requestDetailInfo(id):
        state.spotId = id
        state.isDetailLoading = true
        return requestDetailInfo(id: id)

      case let .fetchDetailInfo(id):
        state.isDetailLoading = true
        return fetchDetailInfo(id: id)

      case let .detailResponse(item):
        state.flowerSpotData = item
        state.spotId = item.id
        // distance 계산
        if let userLocation = state.userLocation {
          state.distance = item.pinPoint.distance(from: userLocation)
        } else {
          state.distance = .zero
        }
        checkLoadingComplete(&state)
        // 이미지 프리페치 시작
        return .send(.prefetchImages)

      case let .bloomingResponse(item):
        state.bloomingStatus = item
        checkLoadingComplete(&state)
        return .none

      case let .verifyTodayBlooming(item):
        state.isVotedBlooming = item
        checkLoadingComplete(&state)
        return .none

      case .delegate, .binding:
        return .none
      }
    }

    private func checkLoadingComplete(_ state: inout State) {
      if state.flowerSpotData.id != 0 && state.bloomingStatus.totalCount >= 0 {
        state.isDetailLoading = false
        state.isNeedDrawPath = true
        if let bloomStatus = BloomStatus(rawValue: state.flowerSpotData.bloomingStatus) {
          state.updateMarkerStatus = bloomStatus
        }
      }
    }
  }
}

extension FlowerSpotDetailFeature.Core {
  private func requestDetailInfo(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        async let detailResult = try flowerSpotClient.getFlowerSpotDetail(id: id)
        async let bloomingResult = try bloomingClient.getBloomingState(id: id)
        let verifyTodayResult = UserDefaultsKeys.isLoggedIn == true
          ? try await bloomingClient.verifyBloomingToday(id: id)
          : VerifyBloomingStateEntity(isBlooming: false)

        let (detail, blooming) = try await (detailResult, bloomingResult)

        await MainActor.run {
          send(.detailResponse(detail))
          send(.bloomingResponse(blooming))
          send(.verifyTodayBlooming(verifyTodayResult))
        }
      } catch let error as NetworkError {
        print("[FlowerSpotDetailFeature] Network Error: \(error.errorDescription)")
      } catch let error as FoundationError {
        print("[FlowerSpotDetailFeature] Foundation Error: \(error.errorDescription)")
      } catch {
        print("[FlowerSpotDetailFeature] Error: \(error.localizedDescription)")
      }
    }
  }

  private func fetchDetailInfo(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        async let detailResult = try flowerSpotClient.getFlowerSpotDetail(id: id)
        async let bloomingResult = try bloomingClient.getBloomingState(id: id)
        async let verifyTodayResult = try bloomingClient.verifyBloomingToday(id: id)

        let (detail, blooming, verifyToday) = try await (detailResult, bloomingResult, verifyTodayResult)

        await MainActor.run {
          send(.detailResponse(detail))
          send(.bloomingResponse(blooming))
          send(.verifyTodayBlooming(verifyToday))
        }
      } catch let error as NetworkError {
        print("[FlowerSpotDetailFeature] Network Error: \(error.errorDescription)")
      } catch let error as FoundationError {
        print("[FlowerSpotDetailFeature] Foundation Error: \(error.errorDescription)")
      } catch {
        print("[FlowerSpotDetailFeature] Error: \(error.localizedDescription)")
      }
    }
  }

  private func prefetchImages(urls: [String]) -> Effect<Action> {
    return .run { [cache] send in
      var result: [String: Data] = [:]

      await withTaskGroup(of: (String, Data?).self) { group in
        for url in urls {
          group.addTask {
            // 1. 캐시 확인
            if let cached: Data = await cache.get(.remoteImage(url: url)) {
              return (url, cached)
            }

            // 2. 네트워크에서 fetch
            guard let imageUrl = URL(string: url),
                  let (data, _) = try? await URLSession.shared.data(from: imageUrl) else {
              return (url, nil)
            }

            // 3. 캐시에 저장
            try? await cache.set(.remoteImage(url: url), data)
            return (url, data)
          }
        }

        for await (url, data) in group {
          if let data {
            result[url] = data
          }
        }
      }

      await send(.imagesPrefetched(result))
    }
  }
}
