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
import Sample1Feature

@Reducer
struct PIDAReducer {
  @ObservableState
  struct State: Equatable {
    var mapRoot = MapRootReducer.State()
  }
  
  enum Action {
    case mapRoot(MapRootReducer.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.mapRoot, action: \.mapRoot) {
      MapRootReducer(sampleReducer: .init())
    }
    Reduce { state, action in
      return .none
    }
  }
}
