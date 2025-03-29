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
        
      case let .configSpotData(id, streetName):
        state.spotId = id
        state.streetName = streetName
        return .none
        
      case .changeStatus:
        if let _ = state.selectedStatus,
            !state.isButtonEnable {
          state.buttonTittle = "기록하기"
          state.isButtonEnable = true
        }
        return .none
        
      case .initialState:
        state.buttonTittle = "개화 상태를 선택해주세요"
        state.selectedStatus = nil
        state.isButtonEnable = false
        return .none
        
      case .dismiss:
        return .run { send in
          await send(.delegate(.dismiss))
          await send(.initialState)
        }
      case .binding, .delegate:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
