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
import LocationClient
import AnalyticsClient

extension LocationFeature {
  
  public init() {
    self.init(reducer: Reduce(Core()))
  }
  
  struct Core: Reducer {
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.analyticsClient) var analyticsClient
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .moveUserLocation:
        let isCurrentButtonTap = state.isCurrentButtonTap
        return moveUserLocation(isCurrentButtonTap: isCurrentButtonTap)
        
      case let .saveUserLocation(location):
        return .send(.delegate(.storeUserLocation(location)))
        
      case let .moveLocation(point):
        state.point = point
        return .none
        
      case let .currentButtonTapped(isTapped):
        state.isCurrentButtonTap = isTapped
        if isTapped {
          analyticsClient.track(MapEvent.currentLocationClicked(currentPage: "map"))
          return .send(.moveUserLocation)
        }
        return .none
        
      case let .fetchFlowers(positions):
        return fetchFlowerSpots(positions: positions)
        
      case let .fetchFlowersInRadius(coordinate, radiusInKm):
        return fetchFlowerSpotsInRadius(coordinate: coordinate, radiusInKm: radiusInKm)
        
      case let .storeFlowerData(data):
        return .send(.delegate(.storeFlowerData(data)))
        
      case let .showToastView(message, buttonLabel):
        return .send(.delegate(.showToastView(message: message, buttonLabel: buttonLabel)))
        
      case let .presentAlert(type):
        return .send(.delegate(.presentAlert(type: type)))
        
      case let .mapSearchError(error):
        print("=============")
        print(error ?? "ERROR!")
        print("=============")
        return .none
        
      case .binding, .delegate: return .none
        
      }
    }
  }
}

extension LocationFeature.Core {
  
  
  private func moveUserLocation(isCurrentButtonTap: Bool) -> Effect<Action> {
    
    
    return .run { send in
      if let location = await locationClient.requestUserLocation() {
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
          swLat: positions[0].latitude,
          swLng: positions[0].longitude,
          neLat: positions[1].latitude,
          neLng: positions[1].longitude
        )
        let result = try await flowerSpotClient.fetchAllFlowerPin(query: query)
        if result.itemList.count == 0 {
          analyticsClient.track(MapEvent.researchFailed)
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
  
  private func fetchFlowerSpotsInRadius(coordinate: Coordinate, radiusInKm: Double) -> Effect<Action> {
    return .run { send in
      do {
        let bounds = coordinate.boundingBoxForRadius(radiusInKm: radiusInKm)
        let query = GetFlowerSpotQuery(
          swLat: bounds[0].latitude,
          swLng: bounds[0].longitude,
          neLat: bounds[1].latitude,
          neLng: bounds[1].longitude
        )
        let result = try await flowerSpotClient.fetchAllFlowerPin(query: query)
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
