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
import DesignKit

extension MapReducer {
  struct LocationReducer: Reducer {
    
    @Dependency(\.fetchAllFlowerPinUseCase) var fetchAllFlowerPinUseCase
    
    public func reduce(into state: inout State, action: LocationAction) -> Effect<LocationAction> {
      
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
        let isCurrentButtonTap = state.location.isCurrentButtonTap
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            let userLocation = MapPoint(latitude: location.0, longitude: location.1)
            await send(.saveUserLocation(userLocation))
            await send(.moveLocation(userLocation))
          } else {
            if isCurrentButtonTap {
              await send(.presentAlert(type: .locationPermission))
              await send(.currentButtonTapped(false))
            }
          }
        }
        
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
          return .send(.fetchUserLocation)
        }
        return .none
        
      case let .fetchFlowers(positions):
        return .run { send in
          do {
            let result = try await fetchAllFlowerPinUseCase.execute(
              region: "SEOUL",
              swLat: positions[0].latitude,
              swLng: positions[0].longitude,
              neLat: positions[1].latitude,
              neLng: positions[1].longitude
            )
            if result.count == 0 {
              await send(.showToastView(message: "이 근방에는 꽃길이 없어요.", buttonLabel: "제보하기"))
            }
            await send(.storeFlowerData(result))
          } catch let error as NetworkError {
            await send(.mapSearchError(error.localizedDescription))
          } catch let error as FoundationError {
            await send(.mapSearchError(error.localizedDescription))
          } catch {
            await send(.mapSearchError(error.localizedDescription))
          }
        }
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
