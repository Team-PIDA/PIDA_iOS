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
    @Dependency(\.fetchFlowersUseCase) var fetchFlower
    
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
          }
        }
      case let .moveLocation(point):
        state.position = point
        return .none
      case .fetchFlowers:
        return .run { send in
          let data = try? await fetchFlower.execute()
          await send(.storeFlowerData(data ?? []))
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
