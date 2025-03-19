//
//  PIDAReducer.swift
//  PIDA
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MapFeatureInterface

@Reducer
struct PIDAReducer {
  @ObservableState
  struct State: Equatable {
    var path = StackState<PathReducer.State>()
    var map = MapReducer.State()
  }
  
  enum Action {
    case path(StackActionOf<PathReducer>)
    case moveFeature(FeatureType)
    case map(MapReducer.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.map, action: \.map) {
      MapReducer()
    }
    Reduce { state, action in
      switch action {
      case let .moveFeature(feature):
        state.path.append(feature.toPathState())
        return .none
      case .path:
        return .none
      case .map:
        return .none
      }
    }
  }
}
