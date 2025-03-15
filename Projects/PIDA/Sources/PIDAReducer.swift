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
  struct State: Equatable {
    var mapView = MapReducer.State()
  }
  
  enum Action {
    case mapView(MapReducer.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.mapView, action: \.mapView) {
      MapReducer()
    }
    
    Reduce { state, action in
      return .none
    }
  }
}
