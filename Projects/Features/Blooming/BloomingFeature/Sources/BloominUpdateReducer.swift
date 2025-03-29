//
//  BloominUpdateReducer.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingFeatureInterface
import ComposableArchitecture
import Utility

extension BloomingUpdateReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.selectedStatus):
        return .send(.changeStatus)
      case .changeStatus:
        if let _ = state.selectedStatus,
            !state.isButtonEnable {
          state.buttonTittle = "기록하기"
          state.isButtonEnable = true
        }
        return .none
        
      case .dismiss:
        return .send(.dismiss)
      case .binding, .delegate:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
