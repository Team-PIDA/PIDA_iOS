//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct SettingReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }

  public enum Action: Equatable {
    case delegate(Delegate)
    case pop
  }
  
  public enum Delegate: Equatable {
    case pop
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
