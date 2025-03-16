//
//  MapReducer.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import ComposableArchitecture
import Utility

extension MapReducer {
  public static let mapReducer = Reduce<State, Action> { state, action in
    switch action {
    case .fetchUserLocation:
      return .run { _ in
        await LocationService.shared.requestUserLocation()
      }
    case let .moveLocation(point):
      state.position = point
      return .none
    case .binding:
      return .none
    }
  }
  
  public init() {
    self.init(reducer: Self.mapReducer)
  }
}
