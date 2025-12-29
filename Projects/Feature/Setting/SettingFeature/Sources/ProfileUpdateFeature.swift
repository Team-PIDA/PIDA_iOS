//
//  ProfileUpdateFeature.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Shared
import ComposableArchitecture
import SettingFeatureInterface
import UserClient

extension ProfileUpdateFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.userClient) var userClient
    @Dependency(\.mainQueue) var mainQueue

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
        if nickname == state.nickname {
          state.inputValid = .none
          state.isValidInput = true
          return .none
        }
        let inputValid: NickNameInputValid
        if nickname.count < 2 { inputValid = .tooShort }
        else if nickname.count > 12 { inputValid = .tooLong }
        else { inputValid = .valid }
        return .send(.nicknameValidMessage(inputValid))

      case let .nicknameValidMessage(type):
        state.inputValid = type
        state.isValidInput = state.inputValid.isValid
        return .none

      case let .changeNickName(nickname):
        return changeNickname(nickname: nickname)

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
  }
}

extension ProfileUpdateFeature.Core {
  private func changeNickname(nickname: String) -> Effect<Action> {
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
      } catch {
        await send(.isLoading(false))
        await send(.showToastView(message: "닉네임 변경에 실패했어요."))
      }
    }
  }
}
