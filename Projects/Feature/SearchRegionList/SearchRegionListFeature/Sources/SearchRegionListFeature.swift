//
//  SearchRegionListFeature.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import SearchRegionListFeatureInterface
import ComposableArchitecture
import FlowerSpotClient
import Shared

extension SearchRegionListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .onAppear:
        return .none
        
      case let .storeFlowerSpots(flowerSpots):
        state.flowerSpots = flowerSpots
        state.isLoading = false
        state.isDataEmpty = flowerSpots.isEmpty
        return .none
        
      case let .flowerSpotTapped(flowerSpot):
        return .send(.delegate(.showFlowerSpotDetail(flowerSpot)))
        
      case .delegate: return .none
      }
    }
  }
}
