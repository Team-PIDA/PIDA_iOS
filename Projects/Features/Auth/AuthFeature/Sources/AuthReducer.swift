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
  public init() {
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .run { send in
          do {
            let authCode = try await AppleLoginHelper.requestAuthorization()
            await send(.appleLoginRespose(authCode))
          } catch {
            print("[AppleLogin Failure] ", error.localizedDescription)
            await send(.appleLoginFailure)
          }
        }
      case let .appleLoginRespose(authCode):
        state.authCode = authCode
        return .none
      case .appleLoginFailure:
        return .none
      }
    }
    self.init(reducer: authReducer)
  }
}
