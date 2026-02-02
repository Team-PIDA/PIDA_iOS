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
import AnalyticsClient

extension SearchRegionListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.flowerSpotClient) var flowerSpotClient
    @Dependency(\.analyticsClient) var analyticsClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .onAppear:
        return .none
        
      case let .storeFlowerSpots(flowerSpots):
        state.flowerSpots = flowerSpots
        state.isLoading = false
        state.isDataEmpty = flowerSpots.isEmpty
        // search_result_viewed 이벤트 트래킹
        analyticsClient.track(
          SearchEvent.resultViewed(
            entryPoint: "search",
            distanceFromRegion: nil,
            scrollItemCount: flowerSpots.count
          )
        )
        return .none
        
      case let .flowerSpotTapped(flowerSpot):
        analyticsClient.track(SearchEvent.resultClicked)
        return .send(.delegate(.showFlowerSpotDetail(flowerSpot)))
        
      case .delegate: return .none
      }
    }
  }
}
