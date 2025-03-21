//
//  MapRootReducer.swift
//  MapDemo
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import MapFeatureInterface

extension MapRootReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      // map -> search
      case .map(.delegate(.presentToSearch)):
        state.isShowSearch = true
        return .none
      // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.path.append(.setting)
        return .none
        
      case .binding, .map:
        return .none
      }
    }
    self.init(
      reducer: reducer,
      mapReducer: .init()
    )
  }
}
