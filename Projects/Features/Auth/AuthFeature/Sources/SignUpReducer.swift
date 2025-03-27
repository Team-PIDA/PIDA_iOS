//
//  SignUpReducer.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import AuthFeatureInterface
import UserDefault

extension SignUpReducer {
  public init() {
    @Dependency(\.signUpUseCase) var signUpUseCase
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.showKeyboard(true))
          }
        }
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
        
      case .confirmTapped:
        return .send(.checkValidNickName(state.nickname))
        
      case let .checkValidNickName(nickname):
        if nickname.count < 2 {
          state.inputValid = .tooShort
          state.isValidInput = false
        } else if nickname.count > 12 {
          state.inputValid = .tooLong
          state.isValidInput = false
        } else {
          state.inputValid = .valid
          state.isValidInput = true
          
          return .send(.requestSignUp(nickname: nickname))
        }
        return .none
        
      case let .requestSignUp(nickname):
        return .run { send in
          do {
            if let email = UserDefault.email {
              try await signUpUseCase.execute(email: email, nickname: nickname)
              await send(.dismiss)
            }
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
