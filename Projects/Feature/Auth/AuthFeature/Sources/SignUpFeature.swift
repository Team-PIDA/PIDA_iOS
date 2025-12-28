//
//  SignUpFeature.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Shared
import ComposableArchitecture
import AuthFeatureInterface
import AuthClient
import UserClient

extension SignUpFeature {
  public init() {
    self.init(reducer: Reduce(SignUpFeature()))
  }

  struct SignUpFeature: Reducer {
    @Dependency(\.authClient) var authClient
    @Dependency(\.userClient) var userClient
    @Dependency(\.mainQueue) var mainQueue

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .binding(\.nickname):
        return .send(.checkValidNickName(state.nickname))

      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.showKeyboard(true))
            send(.initState)
          }
        }

      case let .showToastView(message):
        state.toastMessage = message
        return .none

      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none

      case .initState:
        state.isValidInput = true
        state.inputValid = .none
        state.isLoading = false
        return .none

      case let .isLoading(isLoading):
        state.isLoading = isLoading
        return .none

      case .confirmTapped:
        return .send(.requestSignUp(nickname: state.nickname))
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)

      case let .checkValidNickName(nickname):
        return checkValidNickname(nickname: nickname)

      case let .nicknameValidMessage(type):
        state.inputValid = type
        state.isValidInput = state.inputValid.isValid
        return .none

      case let .requestSignUp(nickname):
        return requestSignUp(nickname: nickname)
        
      case .fetchUserInfo:
        return fetchUserInfo()

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
  }
}

extension SignUpFeature.SignUpFeature {
  private func checkValidNickname(nickname: String) -> Effect<Action> {
    let inputValid: NickNameInputValid
    if nickname.count < 2 {
      inputValid = .tooShort
    } else if nickname.count > 12 {
      inputValid = .tooLong
    } else {
      inputValid = .valid
    }
    return .send(.nicknameValidMessage(inputValid))
  }
  
  private func requestSignUp(nickname: String) -> Effect<Action> {
    return .run { send in
      await send(.isLoading(true))
      do {
        if let email: String = KeyChain.read(forKey: .email) {
          let result = try await authClient.signUp(email: email, nickname: nickname)
          UserDefaultsKeys.isLoggedIn = true
          await send(.showToastView(message: result.message))
          await send(.fetchUserInfo)
        }
      } catch let error as NetworkError {
        if error.errorClassName == .duplicateNickname {
          await send(.nicknameValidMessage(.duplicate))
          await send(.isLoading(false))
        } else {
          await send(.isLoading(false))
          await send(.showToastView(message: "회원가입에 실패했어요."))
        }
      } catch {
        await send(.isLoading(false))
        await send(.showToastView(message: "회원가입에 실패했어요."))
      }
    }
  }
  
  private func fetchUserInfo() -> Effect<Action> {
    return .run { send in
      do {
        let result = try await userClient.fetchUserInfo()
        UserDefaultsKeys.username = result.nickname
        await send(.dismiss)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
