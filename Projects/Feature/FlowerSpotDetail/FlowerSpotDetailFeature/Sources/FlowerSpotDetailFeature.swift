//
//  FlowerSpotDetailFeature.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import Shared
import ComposableArchitecture
import FlowerSpotDetailFeatureInterface

extension FlowerSpotDetailFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      // MARK: - Delegate
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

      case .delegate, .binding:
        return .none
      }
    }
  }
}
