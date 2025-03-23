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
  public init() {
    @Dependency(\.fetchAllFlowerPinUseCase) var fetchAllFlowerPinUseCase
    
    let mapReducer = Reduce<State, Action> {
      state,
      action in
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
          }
        }
      case let .moveLocation(point):
        state.position = point
        return .none
      case .fetchFlowers:
        return .run { send in
          do {
            try await fetchAllFlowerPinUseCase.execute(
              region: "SEOUL",
              swLat: 37.61471008922519,
              swLng: 126.90354953438879,
              neLat: 37.67207092899083,
              neLng: 126.93702350279204
            )
            await send(.storeFlowerData([]))
          } catch let error as NetworkError {
            print(error.localizedDescription)
          } catch let error as FoundationError {
            print(error.localizedDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
      case let .storeFlowerData(data):
        data.forEach {
          state.flowerPositions[$0.id] = $0
        }
        return .none
      case let .fetchPathLines(id):
        if let id = id,
           let data = state.flowerPositions[id] {
          state.selectedPathLines = data.pathLines
        } else {
          state.selectedPathLines = []
        }
        return .none
        
        // MARK: - Search
        
      case let .showSearchResult(result):
        state.searchResult = result
        return .send(.setSearchBarText(result))
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
      case let .requestMapBounds(isRequest):
        state.requestMapBound = isRequest
        return .none
      case .pushToSetting:
        return .send(.delegate(.pushToSetting))
        
        // MARK: - None
        
      case .binding,
          .delegate:
        return .none
      }
    }
    self.init(reducer: mapReducer)
    
  }
}
