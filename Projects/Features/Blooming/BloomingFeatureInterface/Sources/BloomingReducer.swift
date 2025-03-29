//
//  BloomingReducer.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct BloomingReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }

  public enum Action: Equatable {
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
