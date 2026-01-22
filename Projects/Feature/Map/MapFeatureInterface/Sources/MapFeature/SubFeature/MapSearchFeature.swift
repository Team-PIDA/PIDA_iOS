//
//  MapSearchFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 1/21/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared

@Reducer
public struct MapSearchFeature {
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
  }
  
  public enum Delegate: Equatable {
    
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
