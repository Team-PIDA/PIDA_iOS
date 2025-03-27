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
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.showKeyboard(true))
          }
        }
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
      case .dismiss:
        return .run { send in
          await MainActor.run {
            send(.showKeyboard(false))
            send(.delegate(.dismiss))
          }
        }
      case .delegate, .binding:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
