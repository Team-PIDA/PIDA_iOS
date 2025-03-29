//
//  BloomingReducer.swift
//
//  Blooming
//
//  Created by JiYeon
//

import BloomingFeatureInterface
import ComposableArchitecture

extension BloomingReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
