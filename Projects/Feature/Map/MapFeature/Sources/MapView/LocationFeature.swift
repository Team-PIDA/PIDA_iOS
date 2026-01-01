//
//  LocationFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 4/7/25.
//  Copyright © 2025 com.pida.me.ios. All rights reserved.
//

import Shared
import DesignKit
import NMapsMap
import ComposableArchitecture
import MapFeatureInterface
import FlowerSpotClient
import CacheClient
import LocationClient

extension MapFeature {
  struct LocationFeature: Reducer {
    typealias Action = LocationAction
    
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.cache) var cache

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .moveUserLocation:
        let isCurrentButtonTap = state.location.isCurrentButtonTap
        return moveUserLocation(isCurrentButtonTap: isCurrentButtonTap)
        
      case let .saveUserLocation(location):
        state.userLocation = location
        return .none
        
      case let .moveLocation(point):
        state.point = point
        return .none
        
      case let .requestMapBounds(isRequest):
        state.requestMapBound = isRequest
        state.researchButtonEnable = false
        return .none
        
      case let .currentButtonTapped(isTapped):
        state.location.isCurrentButtonTap = isTapped
        if isTapped {
          return .send(.moveUserLocation)
        }
        return .none
        
      case let .fetchFlowers(positions):
        return fetchFlowerSpots(positions: positions)
        
      case let .storeFlowerData(data):
        state.flowerSpots.removeAll()
        data.forEach {
          state.flowerSpots[$0.id] = $0
        }
        return .none
        
      case let .mapSearchError(error):
        print("=============")
        print(error ?? "ERROR!")
        print("=============")
        return .none
        
      case .showToastView, .presentAlert: return .none
        
      }
    }
  }
  
}

extension MapFeature.LocationFeature {
  private func moveUserLocation(isCurrentButtonTap: Bool) -> Effect<Action> {
    return .run { send in
      if let location = try await locationClient.requestUserLocation() {
        await send(.saveUserLocation(location))
        await send(.moveLocation(location))
      } else {
        if isCurrentButtonTap {
          await send(.presentAlert(type: .locationPermission))
          await send(.currentButtonTapped(false))
        }
      }
    }
  }
  
  private func fetchFlowerSpots(positions: [Coordinate]) -> Effect<Action> {
    return .run { send in
      do {
        let query = GetFlowerSpotQuery(
          region: "SEOUL",
          swLat: positions[0].latitude,
          swLng: positions[0].longitude,
          neLat: positions[1].latitude,
          neLng: positions[1].longitude
        )
        let result = try await flowerSpotClient.fetchAllFlowerPin(query: query)
        if result.itemList.count == 0 {
          await send(.showToastView(message: "이 근방에는 꽃길이 없어요.", buttonLabel: "제보하기"))
        }
        await send(.storeFlowerData(result.itemList))
      } catch let error as NetworkError {
        await send(.mapSearchError(error.localizedDescription))
      } catch let error as FoundationError {
        await send(.mapSearchError(error.localizedDescription))
      } catch {
        await send(.mapSearchError(error.localizedDescription))
      }
    }
  }
}
