//
//  ProfileUpdateReducer.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import SettingFeatureInterface
import Utility
import UserDefault

extension ProfileUpdateReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.changeName):
        return .send(.checkValidNickName(state.changeName))
        
      case .onAppear:
        if let nickname = UserDefault.username {
          state.nickname = nickname
          state.changeName = nickname
        }
        return .none
        
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none

      case .saveTapped:
        return .run { send in
          await send(.showKeyboard(false))
          await send(.pop)
        }
        
      case let .checkValidNickName(nickname):
        // 이전 이름과 같을 경우
        if nickname == state.nickname {
          state.inputValid = .none
          state.isValidInput = true
          return .none
        }
        if nickname.count < 2 {
          state.inputValid = .tooShort
        } else if nickname.count > 12 {
          state.inputValid = .tooLong
        } else {
          state.inputValid = .valid
        }
        state.isValidInput = state.inputValid.isValid
        return .none
        
      case .pop:
        state.nickname = ""
        state.inputValid = .none
        return .send(.delegate(.pop))
        
      case .binding, .delegate:
        return .none
      }
    }
    
    self.init(reducer: reducer)
  }
}
