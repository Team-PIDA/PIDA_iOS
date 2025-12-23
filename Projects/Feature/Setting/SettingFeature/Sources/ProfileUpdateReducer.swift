//
//  ProfileUpdateReducer.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Shared
import ComposableArchitecture
import SettingFeatureInterface
import UserClient

extension ProfileUpdateReducer {
  public init() {
    @Dependency(\.userClient) var userClient
    @Dependency(\.mainQueue) var mainQueue
    
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.changeName):
        return .send(.checkValidNickName(state.changeName))
        
      case .onAppear:
        if let nickname = UserDefaultsKeys.username {
          state.nickname = nickname
          state.changeName = nickname
        }
        return .none
        
      case let .showKeyboard(isShow):
        state.focusKeyboard = isShow
        return .none
      case let .showToastView(message):
        state.toastMessage = message
        return .none
        
      case let .isLoading(isLoading):
        state.isLoading = isLoading
        return .none

      case .saveTapped:
        return .send(.changeNickName(state.changeName))
          .throttle(id: ID.throttle, for: 0.3, scheduler: mainQueue, latest: false)
        
      case let .checkValidNickName(nickname):
        // 이전 이름과 같을 경우
        if nickname == state.nickname {
          state.inputValid = .none
          state.isValidInput = true
          return .none
        }
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
        
      case let .changeNickName(nickname):
        return .run { send in
          await send(.isLoading(true))
          do {
            let result = try await userClient.changeNickname(nickname: nickname)
            UserDefaultsKeys.username = result.nickname
            await send(.pop)
          } catch let error as NetworkError {
            if error.errorClassName == .duplicateNickname {
              await send(.isLoading(false))
              await send(.nicknameValidMessage(.duplicate))
            } else {
              await send(.isLoading(false))
              await send(.showToastView(message: "닉네임 변경에 실패했어요."))
            }
          }
          catch {
            await send(.isLoading(false))
            await send(.showToastView(message: "닉네임 변경에 실패했어요."))
          }
        }
      case .pop:
        state.nickname = ""
        state.inputValid = .none
        return .run { send in
          await MainActor.run {
            send(.isLoading(false))
            send(.showKeyboard(false))
            send(.delegate(.pop))
          }
        }
        
        
      case .binding, .delegate:
        return .none
      }
    }
    
    self.init(reducer: reducer)
  }
}
