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
import CategoryClient
import CacheClient
import AnalyticsClient

extension FlowerSpotDetailFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.bloomingClient) var bloomingClient
    @Dependency(\.categoryClient) var categoryClient
    @Dependency(\.cache) var cache
    @Dependency(\.analyticsClient) var analyticsClient
    @Dependency(\.openURL) var openURL

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
          let distance = state.distance > 0 ? state.distance : nil
          return .send(.presentToBlooming(id: id, streetName: streetName, distance: distance))
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

      case let .presentToBlooming(id, streetName, distance):
        return .send(.delegate(.presentToBlooming(id: id, streetName: streetName, distance: distance)))

      case .showLoginAlert:
        state.isShowLoginAlert = true
        return .none

      // MARK: - Navigation (PhotoGallery)

      case .pushToPhotoGallery:
        state.isPresentPhotoGallery = true
        // details_gallery_start 이벤트 트래킹
        analyticsClient.track(
          DetailsEvent.galleryStart(
            distanceFromSpot: state.distance > 0 ? state.distance : nil
          )
        )
        return .none

      case .popFromPhotoGallery:
        state.isPresentPhotoGallery = false
        return .none

      // MARK: - Presentation (PhotoViewer)

      case let .presentPhotoViewer(index):
        state.photoViewer = .init(
          images: state.flowerSpotData.images,
          currentIndex: index
        )
        state.isPresentPhotoViewer = true
        // details_thumbnail_clicked 이벤트 트래킹
        analyticsClient.track(
          DetailsEvent.thumbnailClicked(spotPhoto: state.flowerSpotData.images.count)
        )
        // details_viewer_start 이벤트 트래킹
        analyticsClient.track(
          DetailsEvent.viewerStart(
            distanceFromSpot: state.distance > 0 ? state.distance : nil
          )
        )
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
        if viewer.currentIndex < viewer.images.count - 1 {
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
        let urls = state.flowerSpotData.images.map { $0.url }
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

      case let .detailResponse(item, shouldUpdateMap):
        state.flowerSpotData = item
        state.spotId = item.id
        // distance 계산
        if let userLocation = state.userLocation {
          state.distance = item.pinPoint.distance(from: userLocation)
        } else {
          state.distance = .zero
        }
        checkLoadingComplete(&state)
        // 이미지 프리페치 시작 + 부모에게 최신 데이터 전달
        if shouldUpdateMap {
          // 딥링크 진입: 지도 위치 이동 + 마커 표시
          return .concatenate(
            checkBloomStatus(status: state.flowerSpotData.bloomingStatus),
            .send(.prefetchImages),
            .send(.delegate(.didUpdateFlowerSpot(item)))
          )
        } else {
          // 마커 탭/검색: 프리페치 + 부모 동기화
          return .concatenate(
            checkBloomStatus(status: state.flowerSpotData.bloomingStatus),
            .send(.prefetchImages),
            .send(.delegate(.didUpdateFlowerSpot(item)))
          )
        }

      case let .bloomingResponse(item):
        state.bloomingStatus = item
        checkLoadingComplete(&state)
        return checkBloomStatus(status: state.flowerSpotData.bloomingStatus)

      case let .verifyTodayBlooming(item):
        state.isVotedBlooming = item
        checkLoadingComplete(&state)
        return checkBloomStatus(status: state.flowerSpotData.bloomingStatus)

      // MARK: - Category Detail (v2)

      case let .requestCategoryDetail(categoryId, itemId):
        state.spotId = itemId
        state.isDetailLoading = true
        return requestCategoryDetail(categoryId: categoryId, itemId: itemId)

      case let .categoryDetailResponse(detail):
        state.flowerSpotData = detail.flowerSpotData
        state.bloomingStatus = detail.bloomingStatus
        state.spotCategory = detail.spotCategory
        state.festivalInfo = detail.festivalInfo
        state.cafeInfo = detail.cafeInfo
        state.spotId = detail.flowerSpotData.id
        if let userLocation = state.userLocation {
          state.distance = detail.flowerSpotData.pinPoint.distance(from: userLocation)
        } else {
          state.distance = .zero
        }
        checkLoadingComplete(&state)
        return .concatenate(
          checkBloomStatus(status: state.flowerSpotData.bloomingStatus),
          .send(.prefetchImages),
          .send(.delegate(.didUpdateFlowerSpot(detail.flowerSpotData)))
        )

      case .fetchDetailFailed:
        state.isDetailLoading = false
        return .none

      // MARK: - Analytics

      case .copyAddressTapped:
        state.copyAddressCount += 1
        let scrollTimeToReach: Double
        if let startTime = state.detailsStartTime {
          scrollTimeToReach = Date().timeIntervalSince(startTime)
        } else {
          scrollTimeToReach = 0
        }
        // details_copy_address 이벤트 트래킹
        analyticsClient.track(
          DetailsEvent.copyAddress(
            scrollTimeToReach: scrollTimeToReach,
            copyAddressCount: state.copyAddressCount,
            copyAddressToUpdate: state.bloomingStatus.totalCount
          )
        )
        return .none

      case .scrollReachedBottom:
        guard !state.hasTrackedScrollReachBottom else { return .none }
        state.hasTrackedScrollReachBottom = true
        let scrollTimeToReach: Double
        if let startTime = state.detailsStartTime {
          scrollTimeToReach = Date().timeIntervalSince(startTime)
        } else {
          scrollTimeToReach = 0
        }
        // details_scroll_reach_bottom 이벤트 트래킹
        analyticsClient.track(
          DetailsEvent.scrollReachBottom(scrollTimeToReach: scrollTimeToReach)
        )
        return .none

      // MARK: - External URL

      case let .openURL(urlString):
        guard let url = URL(string: urlString) else { return .none }
        return .run { [openURL] _ in
          await openURL(url)
        }

      case .delegate, .binding:
        return .none
      }
    }

    /// 로딩 완료 여부 체크 (UI 상태 업데이트만)
    private func checkLoadingComplete(_ state: inout State) {
      // 이미 로딩 완료된 경우 스킵
      guard state.isDetailLoading else { return }
      // 모든 데이터가 준비됐는지 확인
      guard state.flowerSpotData.id != 0 && state.bloomingStatus.totalCount >= 0 else { return }

      state.isDetailLoading = false
      state.isNeedDrawPath = true
      
      // Analytics 트래킹
      trackDetailsStart(&state)
      
    }
    
    private func checkBloomStatus(status: String) -> Effect<Action> {
      if let bloomStatus = BloomStatus(rawValue: status) {
        return .send(.delegate(.updateMarkerStatus(bloomStatus)))
      }
      return .none
    }

    /// details_start 및 map_spot_selected 이벤트 트래킹
    private func trackDetailsStart(_ state: inout State) {
      // spotSelected 이벤트 트래킹
      analyticsClient.track(
        MapEvent.spotSelected(
          spotId: state.flowerSpotData.id,
          distanceFromSpot: state.distance > 0 ? state.distance : nil,
          currentBloomStatus: state.flowerSpotData.bloomingStatus,
          visitCount: state.flowerSpotData.recentlyVisitedCount,
          entryPoint: state.entryPoint
        )
      )
      // details_start 이벤트 트래킹 및 시작 시간 기록
      state.detailsStartTime = Date()
      state.hasTrackedScrollReachBottom = false
      state.copyAddressCount = 0
      analyticsClient.track(
        DetailsEvent.start(
          spotId: state.flowerSpotData.id,
          distanceFromSpot: state.distance > 0 ? state.distance : nil,
          currentBloomStatus: state.flowerSpotData.bloomingStatus,
          visitCount: state.flowerSpotData.recentlyVisitedCount
        )
      )
    }
  }
}

extension FlowerSpotDetailFeature.Core {
  /// 마커 탭, 검색 결과 선택 시 호출 (지도 위치 이동 안 함)
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
          send(.detailResponse(detail, shouldUpdateMap: false))
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

  /// 딥링크, 외부 진입 시 호출 (지도 위치 이동 함)
  private func fetchDetailInfo(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        async let detailResult = try flowerSpotClient.getFlowerSpotDetail(id: id)
        async let bloomingResult = try bloomingClient.getBloomingState(id: id)
        let verifyTodayResult = UserDefaultsKeys.isLoggedIn == true
          ? try await bloomingClient.verifyBloomingToday(id: id)
          : VerifyBloomingStateEntity(isBlooming: false)

        let (detail, blooming) = try await (detailResult, bloomingResult)

        await MainActor.run {
          send(.detailResponse(detail, shouldUpdateMap: true))
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

  /// v2 카테고리 상세 API + 투표 검증 호출
  private func requestCategoryDetail(categoryId: Int, itemId: Int) -> Effect<Action> {
    return .run { [categoryClient, bloomingClient] send in
      do {
        let detail = try await categoryClient.fetchCategoryItemDetail(categoryId, itemId)

        // 투표 검증: EVENT → flowerEventId, 나머지 → flowerSpotId (응답의 실제 ID 사용)
        let verifyQuery: BloomingTargetQuery = detail.spotCategory == .festival
          ? .init(flowerEventId: detail.flowerSpotData.id)
          : .init(flowerSpotId: detail.flowerSpotData.id)
        let verifyResult = UserDefaultsKeys.isLoggedIn == true
          ? try await bloomingClient.verifyBloomingTodayByTarget(verifyQuery)
          : VerifyBloomingStateEntity(isBlooming: false)

        await send(.categoryDetailResponse(detail))
        await send(.verifyTodayBlooming(verifyResult))
      } catch {
        if let networkError = error as? NetworkError {
          Logger.log("[FlowerSpotDetailFeature] Category Detail Network Error: \(networkError.errorDescription)", level: .error)
        } else if let foundationError = error as? FoundationError {
          Logger.log("[FlowerSpotDetailFeature] Category Detail Foundation Error: \(foundationError.errorDescription)", level: .error)
        } else {
          Logger.log("[FlowerSpotDetailFeature] Category Detail Error: \(error.localizedDescription)", level: .error)
        }
        await send(.fetchDetailFailed)
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
