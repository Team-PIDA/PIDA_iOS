//
//  AuthFeature.swift
//
//  Auth
//
//  Created by JiYeon
//

import Shared
import ComposableArchitecture
import AuthFeatureInterface
import AuthClient
import UserClient

extension AuthFeature {
  public init() {
    self.init(reducer: Reduce(AuthFeature()))
  }

  struct AuthFeature: Reducer {
    @Dependency(\.authClient) var authClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.mainQueue) var mainQueue

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .appleLoginButtonTapped:
        return .send(.appleLoginRequest)
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)

      case .appleLoginRequest:
        return appleLoginRequest()
        
      case let .appleLoginResponse(info):
        return handleAppleLoginResponse(info: info)
        
      case .fetchUserInfo:
        let spotId = state.spotId
        return fetchUserInfo(spotId: spotId)
        
      case let .setSpotId(id):
        state.spotId = id
        return .none

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
  }
}

extension AuthFeature.AuthFeature {
  private func appleLoginRequest() -> Effect<Action> {
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
  }
  
  private func handleAppleLoginResponse(info: AppleLoginResult) -> Effect<Action> {
    if let email = info.email {
      KeyChain.save(email, forKey: .email)
    }
    return .run { send in
      do {
        let result = try await authClient.appleLogin(token: info.idToken)
        try await authClient.saveTokenInfo(entity: result)
        if result.isTempToken {
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
  }
  
  private func fetchUserInfo(spotId: Int?) -> Effect<Action> {
    return .run { send in
      do {
        let result = try await userClient.fetchUserInfo()
        UserDefaultsKeys.username = result.nickname
        if let spotId = spotId { await send(.dismissWithVerifyBloomState(id: spotId)) }
        else { await send(.dismiss) }
      } catch let error as NetworkError {
        print(error.errorDescription)
      } catch let error as FoundationError {
        print(error.errorDescription)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
