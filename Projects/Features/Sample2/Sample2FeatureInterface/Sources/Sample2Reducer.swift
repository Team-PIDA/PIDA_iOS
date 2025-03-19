//
//  Sample2Reducer.swift
//
//  Sample2
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct Sample2Reducer {
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
