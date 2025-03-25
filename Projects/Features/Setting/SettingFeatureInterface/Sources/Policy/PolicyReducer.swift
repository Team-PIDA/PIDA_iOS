//
//  PolicyReducer.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct PolicyReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  @ObservableState
  public struct State: Equatable {
    public var type: PolicyType? = nil
    public init(){}
  }
  
  public enum Action: Equatable {
    case pop
    case delegate(Delegate)
    case clearType
  }
  
  public enum Delegate: Equatable {
    case pop
  }
  
  public var body: some ReducerOf<Self> {
    reducer
  }
}
