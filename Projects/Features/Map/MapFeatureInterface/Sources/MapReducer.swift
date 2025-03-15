//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var text: String = ""
    public init() {}
  }
  
  public enum Action: Equatable {
    case events
  }
  
  public var body: some ReducerOf<Self> {
    reducer
  }
}
