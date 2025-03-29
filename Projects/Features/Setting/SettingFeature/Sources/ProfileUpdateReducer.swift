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

extension ProfileUpdateReducer {
  public init() {
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        
        return .none
        
      case .saveTapped:
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
          // TODO: - API 연결
          return .send(.pop)
        }
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
