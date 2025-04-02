//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ComposableArchitecture

@Reducer
public struct FlowerSpotDetailReducer {
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
    
    case delegate(Delegate)
    case dismiss
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
