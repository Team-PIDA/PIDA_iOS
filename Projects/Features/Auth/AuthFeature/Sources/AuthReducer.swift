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
import KeyChain

extension AuthReducer {
  public init() {
    @Dependency(\.appleLoginUseCase) var appleLoginUseCase
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .run { send in
          do {
            // 애플로그인 요청
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
            // 토큰 저장
            UserDefault.accessToken = result.accessToKen
            let _ = KeyChainWrapper.save(result.refreshToken, forKey: .refreshToken)
            
            if result.isTempToken { // 최초 회원가입
              await send(.presentToSignUp(email: info.email))
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
      case let .presentToSignUp(email):
        return .send(.delegate(.presentToSignUp(email: email)))
        
      case .dismiss:
        return .send(.delegate(.dismiss))
      
      case .appleLoginFailure, .delegate:
        return .none
      }
    }
    self.init(reducer: authReducer)
  }
}
