//
//  PolicyFeature.swift
//  SettingFeature
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import SettingFeatureInterface

extension PolicyFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
  }
}
