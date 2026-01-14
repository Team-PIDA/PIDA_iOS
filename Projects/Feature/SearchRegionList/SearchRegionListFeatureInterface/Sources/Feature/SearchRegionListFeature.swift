//
//  SearchRegionListFeature.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import ComposableArchitecture
import SearchClient

@Reducer
public struct SearchRegionListFeature {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var region: RegionInfoEntity
    
    public init(region: RegionInfoEntity) {
      self.region = region
    }
  }

  public enum Action: Equatable {
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
