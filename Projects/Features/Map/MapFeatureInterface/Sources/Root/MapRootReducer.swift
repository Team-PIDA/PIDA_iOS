//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SearchFeatureInterface

public enum MapPath: Hashable {
  case search
  case setting
}

@Reducer
public struct MapRootReducer {
  private let reducer: Reduce<State, Action>
  public let mapReducer: MapReducer
  public let searchReducer: SearchReducer
  
  public init(
    reducer: Reduce<State, Action>,
    mapReducer: MapReducer,
    searchReducer: SearchReducer
  ) {
    self.reducer = reducer
    self.mapReducer = mapReducer
    self.searchReducer = searchReducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var map = MapReducer.State()
    public var search = SearchReducer.State()
    
    /// 네비게이션 이동 경로
    public var path: [MapPath] = []
    public var isShowSearch: Bool = false
    public var isShowSetting: Bool = false
    public init(){}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case presentSearch(Bool)
    
    case map(MapReducer.Action)
    case search(SearchReducer.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.map, action: \.map) {
      mapReducer
    }
    Scope(state: \.search, action: \.search) {
      searchReducer
    }
    BindingReducer()
    reducer
  }
}
