//
//  SignUpReducer.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import AuthFeatureInterface
import UserDomainInterface
import KeyChain
import UserDefault
import Utility

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
            send(.initState)
            send(.showKeyboard(true))
          }
        }
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
        
      case .initState:
        state.nickname = ""
        state.isValidInput = true
        state.inputValid = .none
        state.isLoading = false
        
        return .none
      case .confirmTapped:
        return .send(.requestSignUp(nickname: state.nickname))
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)
        
      case let .checkValidNickName(nickname):
        if nickname.count < 2 {
          state.inputValid = .tooShort
        } else if nickname.count > 12 {
          state.inputValid = .tooLong
        } else {
          state.inputValid = .valid
        }
        state.isValidInput = state.inputValid.isValid
        return .none
        
      case let .requestSignUp(nickname):
        state.isLoading = true
        return .run { send in
          do {
            if let email: String = KeyChainWrapper.read(forKey: .email) {
              try await signUpUseCase.execute(email: email, nickname: nickname)
              UserDefault.isLoggedIn = true
              await send(.fetchUserInfo)
            }
          } catch {
            print(error.localizedDescription)
          }
        }
      case .failSignUp:
        state.isLoading = false
        return .none
        
      case .fetchUserInfo:
        return .run { send in
          do {
            let result = try await userInfoUseCase.execute()
            UserDefault.username = result.nickname
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
