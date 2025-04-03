//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import FlowerSpotDetailFeatureInterface
import ComposableArchitecture
import UserDefault

extension FlowerSpotDetailReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      // MARK: - Delegate
      case let .showToastView(message):
        state.toastMessage = message
        return .none
      case .onAppear:
        state.isNeedDrawPath = true
        return .none
      case .chechAuth:
        if UserDefault.isLoggedIn == true {
          let streetName = state.flowerSpotData.streetName
          return .send(.presentToBlooming(streetName: streetName))
        } else {
          return .send(.showLoginAlert)
        }
      case .alertCancelTapped:
        state.isShowLoginAlert = false
        return .none
      case .alertAcceptTapped:
        state.isShowLoginAlert = false
        return .run { send in
          await send(.delegate(.presentToLogin))
        }
      case .dismiss:
        state.isNeedDeletePath = true
        return .send(.delegate(.dismiss))
      case let .presentToBlooming(streetName):
        return .send(.delegate(.presentToBlooming(streetName: streetName)))
      case .showLoginAlert:
        state.isShowLoginAlert = true
        return .none
      case .delegate, .binding: return .none
      }
    }
    self.init(reducer: reducer)
  }
}
