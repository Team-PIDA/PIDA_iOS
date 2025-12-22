//
//  SignUpReducer.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import AuthFeatureInterface
import Shared

extension SignUpReducer {
  public init() {
    @Dependency(\.fetchUserInfoUseCase) var userInfoUseCase
    @Dependency(\.signUpUseCase) var signUpUseCase
    @Dependency(\.mainQueue) var mainQueue
    let reducer = Reduce<State, Action> { state, action in
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
        let inputValid: NickNameInputValid
        if nickname.count < 2 {
          inputValid = .tooShort
        } else if nickname.count > 12 {
          inputValid = .tooLong
        } else {
          inputValid = .valid
        }
        return .send(.nicknameValidMessage(inputValid))
        
      case let .nicknameValidMessage(type):
        state.inputValid = type
        state.isValidInput = state.inputValid.isValid
        return .none
        
      case let .requestSignUp(nickname):
        return .run { send in
          await send(.isLoading(true))
          do {
            if let email: String = KeyChain.read(forKey: .email) {
              try await signUpUseCase.execute(email: email, nickname: nickname)
              UserDefaultsKeys.isLoggedIn = true
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
          }
          catch {
            await send(.isLoading(false))
            await send(.showToastView(message: "회원가입에 실패했어요."))
          }
        }
        
      case .fetchUserInfo:
        return .run { send in
          do {
            let result = try await userInfoUseCase.execute()
            UserDefaultsKeys.username = result.nickname
            await send(.dismiss)
          } catch {
            print(error.localizedDescription)
          }
        }
        
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
