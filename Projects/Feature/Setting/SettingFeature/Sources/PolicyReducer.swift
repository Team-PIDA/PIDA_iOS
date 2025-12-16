//
//  PolicyReducer.swift
//  SettingFeature
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SettingFeatureInterface
import ComposableArchitecture

extension PolicyReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .pop:
        return .run { send in
          await MainActor.run {
            send(.delegate(.pop))
            send(.clearType)
          }
        }
      case .clearType:
        state.type = nil
        return .none
      case .delegate:
        return .none
      }
      
    }
    self.init(reducer: reducer)
  }
}
