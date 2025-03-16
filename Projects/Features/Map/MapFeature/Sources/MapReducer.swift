//
//  MapReducer.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import MapDomainInterface
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
    case .fetchFlowers:
      testData.forEach {
        state.flowerPositions[$0.id] = $0
      }
      return .none
    case .binding:
      return .none
    }
  }
  
  public init() {
    self.init(reducer: Self.mapReducer)
  }
}


let testData: [FlowerPosition] = [
  FlowerPosition(
    id: 1,
    state: .many,
    currentPosition: MapPoint(latitude: 37.50656, longitude: 127.09729),
    pathLines: [
      MapPoint(latitude: 37.511928, longitude: 127.108091),
      MapPoint(latitude: 37.50891, longitude: 127.10423),
      MapPoint(latitude: 37.50646, longitude: 127.09875),
      MapPoint(latitude: 37.50656, longitude: 127.09729),
      MapPoint(latitude: 37.50792, longitude: 127.08860),
      MapPoint(latitude: 37.50929, longitude: 127.08652),
      MapPoint(latitude: 37.516194, longitude: 127.084444)
    ]
  ),
  FlowerPosition(
    id: 2,
    state: .many,
    currentPosition: MapPoint(latitude: 37.51013, longitude: 127.09919),
    pathLines: [
      MapPoint(latitude: 37.513628, longitude: 127.107195),
      MapPoint(latitude: 37.51159, longitude: 127.10288),
      MapPoint(latitude: 37.51152, longitude: 127.10255),
      MapPoint(latitude: 37.51064, longitude: 127.10067),
      MapPoint(latitude: 37.51013, longitude: 127.09919),
      MapPoint(latitude: 37.50998, longitude: 127.09840),
      MapPoint(latitude: 37.50999, longitude: 127.09753),
      MapPoint(latitude: 37.51031, longitude: 127.09311),
      MapPoint(latitude: 37.516997, longitude: 127.090685)
    ]
  )
]
