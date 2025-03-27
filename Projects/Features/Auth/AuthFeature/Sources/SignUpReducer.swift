//
//  SignUpReducer.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import AuthFeatureInterface

extension SignUpReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .dismiss:
        return .send(.delegate(.dismiss))
      case .delegate:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
