//
//  AuthReducer.swift
//
//  Auth
//
//  Created by JiYeon
//

import AuthFeatureInterface
import UserDomainInterface
import ComposableArchitecture
import Shared

extension AuthReducer {
  public init() {
    @Dependency(\.fetchUserInfoUseCase) var userInfoUseCase
    @Dependency(\.appleLoginUseCase) var appleLoginUseCase
    @Dependency(\.tokenSaveUseCase) var tokenSaveUseCase
    @Dependency(\.mainQueue) var mainQueue
    
    let authReducer = Reduce<State, Action> { state, action in
      switch action {
      case .appleLoginButtonTapped:
        return .send(.appleLoginRequest)
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)
      case .appleLoginRequest:
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
        if let email = info.email {
          KeyChainWrapper.save(email, forKey: .email)
        }
        return .run { send in
          do {
            let result = try await appleLoginUseCase.execute(token: info.idToken)
            // 토큰 저장
            await tokenSaveUseCase.execute(tokenInfo: result)
            if result.isTempToken { // 최초 회원가입
              await send(.presentToSignUp)
            } else {
              await send(.fetchUserInfo)
            }
          } catch let error as NetworkError {
            print(error.errorDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
      case .fetchUserInfo:
        let spotId = state.spotId
        return .run { send in
          do {
            let result = try await userInfoUseCase.execute()
            UserDefaultsKeys.username = result.nickname
            if let spotId = spotId {
              await send(.dismissWithVerifyBloomState(id: spotId))
            } else {
              await send(.dismiss)
            }
          } catch let error as NetworkError {
            print(error.errorDescription)
          } catch let error as FoundationError {
            print(error.errorDescription)
          } catch {
            print(error.localizedDescription)
          }
        }
      case let .setSpotId(id):
        state.spotId = id
        return .none
        // 최초 로그인 시 회원가입(닉네임 입력)화면 이동
      case .presentToSignUp:
        return .send(.delegate(.presentToSignUp))
      case .dismiss:
        state.spotId = nil
        return .send(.delegate(.dismiss))
      case let .dismissWithVerifyBloomState(id):
        state.spotId = nil
        return .send(.delegate(.dismissWithVerifyBloomState(id: id)))
      case .appleLoginFailure, .delegate:
        return .none
      }
    }
    self.init(reducer: authReducer)
  }
}
