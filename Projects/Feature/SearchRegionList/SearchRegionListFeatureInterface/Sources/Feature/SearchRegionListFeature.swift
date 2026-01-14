//
//  SearchRegionListFeature.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import ComposableArchitecture
import SearchClient
import Shared
import FlowerSpotClient

@Reducer
public struct SearchRegionListFeature {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var region: RegionInfoEntity
    public var flowerSpots: [FlowerSpotEntity] = []
    
    public init(region: RegionInfoEntity) {
      self.region = region
    }
  }

  public enum Action: Equatable {
    case onAppear
    case storeFlowerSpots([FlowerSpotEntity])
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
