//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import FlowerSpotDetailFeatureInterface
import ComposableArchitecture

extension FlowerSpotDetailReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      // MARK: - Delegate
      case .onAppear:
        state.isNeedDrawPath = true
        return .none
      case .dismiss:
        state.isNeedDeletePath = true
        return .send(.delegate(.dismiss))
        
      case .delegate, .binding: return .none
      }
    }
    self.init(reducer: reducer)
  }
}
