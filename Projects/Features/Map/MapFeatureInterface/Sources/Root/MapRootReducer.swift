//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture

public enum MapPath: Hashable {
  case search
  case setting
}

@Reducer
public struct MapRootReducer {
  private let reducer: Reduce<State, Action>
  public let mapReducer: MapReducer
  
  public init(
    reducer: Reduce<State, Action>,
    mapReducer: MapReducer
  ) {
    self.reducer = reducer
    self.mapReducer = mapReducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var map = MapReducer.State()
    
    /// 네비게이션 이동 경로
    public var path: [MapPath] = []
    /// present
    public var isShowDetails: Bool = false
    
    public init(){}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    case map(MapReducer.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.map, action: \.map) {
      mapReducer
    }
    BindingReducer()
    reducer
  }
}
