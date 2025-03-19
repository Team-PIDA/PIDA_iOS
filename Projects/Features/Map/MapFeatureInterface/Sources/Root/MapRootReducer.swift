//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Sample1FeatureInterface

@Reducer
public struct MapRootReducer {
  private let reducer: Reduce<State, Action>
  public let mapReducer: MapReducer
  public let sampleReducer: Sample1Reducer
  
  public init(
    reducer: Reduce<State, Action>,
    mapReducer: MapReducer,
    sampleReducer: Sample1Reducer
  ) {
    self.reducer = reducer
    self.mapReducer = mapReducer
    self.sampleReducer = sampleReducer
  }
  
  @ObservableState
  public struct State: Equatable {
    var map = MapReducer.State()
    var sample = Sample1Reducer.State()
    public init(){}
  }
  
  public enum Action: BindableAction {
    case map(MapReducer.Action)
    case sample(Sample1Reducer.Action)
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.map, action: \.map) {
      mapReducer
    }
    Scope(state: \.sample, action: \.sample) {
      sampleReducer
    }
    BindingReducer()
    reducer
  }
}
