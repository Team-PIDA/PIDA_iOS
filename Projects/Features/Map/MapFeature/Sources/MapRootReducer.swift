//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MapFeatureInterface
import Sample1FeatureInterface

extension MapRootReducer {
  public init(sampleReducer: Sample1Reducer) {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .map(.delegate(.pushToSetting)):
        state.path.append(.setting)
        return .none
      case .map(.delegate(.presentToDetail)):
        state.isShowDetails = true
        return .none
      case .binding, .map:
        return .none
      }
    }
    self.init(
      reducer: reducer,
      mapReducer: .init(),
      sampleReducer: sampleReducer
    )
  }
}
