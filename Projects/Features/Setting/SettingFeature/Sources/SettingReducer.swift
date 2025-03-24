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
      case let .settingListTapped(type):
        print(type)
        return .none
      case .pop:
        return .send(.delegate(.pop))
        
      case .delegate:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
