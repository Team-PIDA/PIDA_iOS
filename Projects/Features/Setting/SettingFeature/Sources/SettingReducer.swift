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
  public static let SettingReducer = Reduce<State, Action> { state, action in
    switch action {
    default:
      return .none
    }
  }
}
