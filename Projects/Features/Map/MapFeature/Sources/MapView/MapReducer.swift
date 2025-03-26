//
//  MapReducer.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import FlowerSpotDomainInterface
import ComposableArchitecture
import Utility

extension MapReducer {
  public init() {
    @Dependency(\.fetchAllFlowerPinUseCase) var fetchAllFlowerPinUseCase
    
    let mapReducer = Reduce<State, Action> { state, action in
      switch action {
        
        // MARK: - Map
        
      case .fetchUserLocation:
        return .run { _ in
          await LocationService.shared.requestUserLocation()
        }
      case .moveUserLocation:
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            await send(.moveLocation(MapPoint(latitude: location.0, longitude: location.1)))
            await send(.requestMapBounds(true))
          } else {
            await send(.requestMapBounds(true))
          }
        }
      case let .moveLocation(point):
        state.point = point
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
      case let .fetchPathLines(id):
        if let id = id,
           let data = state.flowerSpots[id] {
          state.selectedPathLines = data.path
        } else {
          state.selectedPathLines = []
          state.searchResult = nil
        }
        return .none
        
      case let .mapSearchError(error):
        print("=============")
        print(error ?? "ERROR!")
        print("=============")
        return .none
        
      case let .requestMapBounds(isRequest):
        state.requestMapBound = isRequest
        state.researchButtonEnable = false
        return .none
        
      case let .selectedItem(item):
        state.selectedItem = item
        
        return .send(.fetchPathLines(id: item.id))
        
        // MARK: - Search
        
      // 검색 결과
      case let .showSearchResult(result):
        state.searchResult = result
        return .run { send in
          if let result = result {
            await send(.setSearchBarText(result.streetName))
            await send(.moveLocation(result.pinPoint))
            
          }
        }
      case let .setSearchBarText(text):
        state.searchText = text
        return .none
      case .resetSearchBar:
        return .run { send in
          await MainActor.run {
            send(.showSearchResult(nil))
            send(.setSearchBarText(nil))
            send(.delegate(.resetSearchView))
          }
        }
        
        // MARK: - Delegate
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch))
      case .pushToSetting:
        return .send(.delegate(.pushToSetting))
        
        // MARK: - None
        
      case .binding, .delegate:
        return .none
      }
    }
    self.init(reducer: mapReducer)
    
  }
}
