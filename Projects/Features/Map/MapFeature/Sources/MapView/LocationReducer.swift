//
//  locationReducer.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import MapFeatureInterface
import FlowerSpotDomainInterface
import ComposableArchitecture
import Utility

extension MapReducer {
  struct LocationReducer: Reducer {
    public func reduce(into state: inout LocationState, action: LocationAction) -> Effect<LocationAction> {
      
      switch action {
      case .fetchUserLocation:
        let point = state.point
        return .run { send in
          await LocationService.shared.requestUserLocation()
          if let point = point {
            await MainActor.run {
              send(.moveLocation(point))  // 현재 저장된 위치로 이동
            }
            
          }
        }
        
      case .moveUserLocation:
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            let userLocation = MapPoint(latitude: location.0, longitude: location.1)
            await send(.saveUserLocation(userLocation))
            await send(.moveLocation(userLocation))
          }
        }
        
      case let .saveUserLocation(location):
        state.userLocation = location
        return .none
        
      case let .moveLocation(point):
        state.point = point
        return .none
        
      }
    }
  }
  
}
