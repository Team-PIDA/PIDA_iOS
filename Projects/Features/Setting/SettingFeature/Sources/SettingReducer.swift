//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import SettingFeatureInterface
import ComposableArchitecture

extension SettingReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        return .none
      case .settingListTapped(.terms):
        return .send(.delegate(.pushToPolicy(.terms)))
      case .settingListTapped(.privacy):
        return .send(.delegate(.pushToPolicy(.privacy)))
      case .pop:
        return .send(.delegate(.pop))
        
      case .delegate, .settingListTapped:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
