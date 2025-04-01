//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import SettingFeatureInterface
import AuthDomainInterface
import UserDomainInterface

import ComposableArchitecture
import Utility
import UserDefault

extension SettingReducer {
  public init() {
    @Dependency(\.openURL) var openURL
    @Dependency(\.tokenDeleteUseCase) var tokenDeleteUseCase
    @Dependency(\.withdrawUseCase) var withdrawUseCase
    @Dependency(\.logoutUseCase) var logoutUseCase
    
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.checkLoggedIn)
          await send(.checkVersion)
        }
      case .checkVersion:
        return .run { send in
          let versionInfo = await AppVersionManager.shared.getVersionInfo()
          let version = "v\(versionInfo.appStore)/v\(versionInfo.current)"
          await send(.configVersionInfo(version, versionInfo.updateNeeded))
        }
      case let .configVersionInfo(version, inNeedUpdate):
        state.version = version
        state.isNeedUpdate = inNeedUpdate
        return .none
      case .checkLoggedIn:
        let isLoggedIn = UserDefault.isLoggedIn ?? false
        state.isLoggedIn = isLoggedIn
        if isLoggedIn {
          return .send(.checkUserInfo)
        }
        return .none
        
      case .checkUserInfo:
        if let username = UserDefault.username {
          state.username = username
        }
        return .none
      case .profileTapped:
        if !state.isLoggedIn {
          return .send(.delegate(.presentToLogin))
        } else {
          return .send(.delegate(.presentToUpdateProfile))
        }
      case .feedBackTapped:
        return .run { send in
          if let url = ExternalURL.feedBack {
            await openURL(url)
          }
        }
        
      case .deleteToken:
        return .run { send in
          await tokenDeleteUseCase.execute()
          await send(.checkLoggedIn)
        }
        
        // MARK: - SettingList Events
        
      case .settingListTapped(.update):
        if state.isNeedUpdate {
          return .run { _ in
            if let url = ExternalURL.appStore {
              await openURL(url)
            } else {
              print("앱스토어 이동 실패")
            }
          }
        }
        return .none
        
      case .settingListTapped(.terms):
        return .send(.delegate(.pushToPolicy(.terms)))
      case .settingListTapped(.privacy):
        return .send(.delegate(.pushToPolicy(.privacy)))
      case .settingListTapped(.logout):
        state.isAlertShow = true
        state.alertType = .logout
        return .none
      case .settingListTapped(.withdraw):
        state.isAlertShow = true
        state.alertType = .withdraw
        return .none
        
        // MARK: - Alert
        
      case .alertCancelTapped:
        return .send(.clearAlertState)
      case .alertAcceptTapped(.withdraw):
        return .run { send in
          do {
            try await withdrawUseCase.execute()
          } catch { }
          await send(.deleteToken)
          await send(.clearAlertState)
        }
      case .alertAcceptTapped(.logout):
        return .run { send in
          do {
            try await logoutUseCase.execute()
          } catch { }
          await send(.deleteToken)
          await send(.clearAlertState)
        }
        
      case .clearAlertState:
        state.isAlertShow = false
        state.alertType = nil
        return .none
        
        // MARK: - Delegate
        
      case .pop:
        return .send(.delegate(.pop))
        
        // MARK: - None
        
      case .delegate, .settingListTapped, .binding, .alertAcceptTapped:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
