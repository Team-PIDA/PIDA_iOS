//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import MapDomainInterface
import FlowerSpotDomainInterface
import ComposableArchitecture

@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var position: MapPoint? = nil
    public var flowerPositions: [Int: FlowerPosition] = [:]
    public var selectedPathLines: [MapPoint] = []
    public var searchResult: String? = nil
    public var searchText: String? = nil
    public var requestMapBound: Bool = false
    public var researchButtonEnable: Bool = false
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: - Map
    
    case fetchUserLocation
    case moveUserLocation
    case moveLocation(MapPoint)
    case fetchFlowers([MapPoint])
    case storeFlowerData([FlowerPosition])
    case fetchPathLines(id: Int?)
    case requestMapBounds(Bool)
    
    // MARK: - Search
    
    case showSearchResult(String?) // TODO: - ItemType
    case setSearchBarText(String?)
    case resetSearchBar
    
    // MARK: - Delegate
    
    case delegate(Delegate)
    case presentToSearch
    case pushToSetting
  }
  
  public enum Delegate: Equatable {
    case presentToSearch
    case pushToSetting
    case resetSearchView
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
