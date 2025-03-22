//
//  AuthReducer.swift
//
//  Auth
//
//  Created by JiYeon
//

import AuthFeatureInterface
import ComposableArchitecture

extension AuthReducer {
  public static let AuthReducer = Reduce<State, Action> { state, action in
    switch action {
    default:
      return .none
    }
  }
}
