//
//  CategoryFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CategoryFeature {
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
  }

  public enum Delegate: Equatable {
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
