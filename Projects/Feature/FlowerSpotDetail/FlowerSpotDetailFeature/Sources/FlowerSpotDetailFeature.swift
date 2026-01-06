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
    // MARK: - Client Dependencies (신규 추가)
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

      // MARK: - 신규 Action (DetailFeature에서 흡수)

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
        // distance 계산은 MapFeature에서 userLocation 기반으로 처리
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

    // MARK: - Helper Methods

    /// 모든 데이터가 로드되었는지 확인하고 로딩 상태 업데이트
    private func checkLoadingComplete(_ state: inout State) {
      // flowerSpotData.id가 0이 아니면 데이터가 로드된 것으로 판단
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

// MARK: - API Methods

extension FlowerSpotDetailFeature.Core {
  /// 초기 데이터 로딩 (바텀시트 표시 시)
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

  /// 데이터 재로딩 (Blooming 완료 후)
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
