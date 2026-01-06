//
//  FlowerSpotDetailFeature.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import Shared
import DesignKit
import ComposableArchitecture
import FlowerSpotDetailFeatureInterface
import FlowerSpotClient
import BloomingClient

extension FlowerSpotDetailFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.bloomingClient) var bloomingClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      // MARK: - Toast
      case let .showToastView(message):
        state.toastMessage = message
        return .none

      case .onAppear:
        state.isNeedDrawPath = true
        return .none

      case .chechAuth:
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
        return .none

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
        // 마커 상태 업데이트
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
}
