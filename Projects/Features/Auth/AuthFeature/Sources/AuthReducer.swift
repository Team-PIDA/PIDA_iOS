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
    @Dependency(\.appleLoginUseCase) var appleLoginUseCase
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .run { send in
          do {
            if let result = try await AppleLoginHelper.requestAuthorization() {
              await send(.appleLoginResponse(result))
            }
          } catch {
            print("[AppleLogin Failure] ", error.localizedDescription)
            await send(.appleLoginFailure)
          }
        }
      case let .appleLoginResponse(info):
        return .run { send in
          do {
            let result = try await appleLoginUseCase.execute(token: info.idToken)
            UserDefault.accessToken = result.accessToKen
            if result.isTempToken {
              await send(.presentToSignUp)
            } else {
              await send(.dismiss)
            }
          } catch let error as NetworkError {
            print(error.localizedDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
        
      case .presentToSignUp:
        return .send(.delegate(.presentToSignUp))
        
      case .dismiss:
        return .send(.delegate(.dismiss))
      
      case .appleLoginFailure, .delegate:
        return .none
      }
    }
    self.init(reducer: authReducer)
  }
}
