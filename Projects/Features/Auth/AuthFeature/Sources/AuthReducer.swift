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
    @Dependency(\.tokenSaveUseCase) var tokenSaveUseCase
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .run { send in
          do {
            // 애플로그인 요청
            if let result = try await AppleLoginHelper.requestAuthorization() {
              UserDefault.email = result.email
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
            // 토큰 저장
            await tokenSaveUseCase.execute(tokenInfo: result)
            
            if result.isTempToken { // 최초 회원가입
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
        
        // 최초 로그인 시 회원가입(닉네임 입력)화면 이동
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
