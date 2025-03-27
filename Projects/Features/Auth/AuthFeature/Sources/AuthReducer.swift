//
//  AuthReducer.swift
//
//  Auth
//
//  Created by JiYeon
//

import AuthFeatureInterface
import ComposableArchitecture
import Utility
import UserDefault

extension AuthReducer {
  public init() {
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .run { send in
          do {
            let result = try await AppleLoginHelper.requestAuthorization()
            await send(.appleLoginResponse(result))
          } catch {
            print("[AppleLogin Failure] ", error.localizedDescription)
            await send(.appleLoginFailure)
          }
        }
      case let .appleLoginResponse(info):
        if let email = info?.email {
          UserDefault.email = info?.email
        }
        // TODO: - 서버에 로그인 요청
        return .send(.presentToSignUp)
        
      case .presentToSignUp:
        return .send(.presentToSignUp)
        
      case .dismiss:
        return .send(.delegate(.dismiss))
      
      case .appleLoginFailure, .delegate:
        return .none
      }
    }
    self.init(reducer: authReducer)
  }
}
