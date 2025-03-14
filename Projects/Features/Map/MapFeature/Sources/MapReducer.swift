//
//  MapReducer.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import ComposableArchitecture

extension MapReducer {
  public static let mapReducer = Reduce<State, Action> { state, action in
    switch action {
    case .events:
      state.text = "hello"
      return .none
    }
  }
  
  public init() {
    self.init(reducer: Self.mapReducer)
  }
}
