//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct SearchReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
