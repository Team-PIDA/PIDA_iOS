//
//  RouterView.swift
//  PIDA
//
//  Created by Jiyeon on 3/19/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MapFeatureInterface
import MapFeature
import Sample1FeatureInterface
import Sample1Feature

@Reducer
enum PathReducer {
  case map(MapReducer)
  case sample1(Sample1Reducer)
}

extension PathReducer.State: Equatable {}

enum FeatureType {
  case map, sample1
  func toPathState() -> PathReducer.State {
    switch self {
    case .map:
      return .map(MapReducer.State())
    case .sample1:
      return .sample1(Sample1Reducer.State())
    }
  }
}

struct NavigationHandler: View {
  let store: StoreOf<PathReducer>
  
  var body: some View {
    switch store.case {
    case let .map(reducer):
      MapView(store: reducer)
    case let .sample1(reducer):
      Sample1View(store: reducer)
    }
  }
}
