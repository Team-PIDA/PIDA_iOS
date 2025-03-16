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
    case .moveUserLocation:
      if let userLocation = LocationService.shared.userLostion {
        return .send(
          .moveLocation(
            .init(
              latitude: userLocation.0,
              longitude: userLocation.1
            )
          )
        )
      }
      return .none
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
