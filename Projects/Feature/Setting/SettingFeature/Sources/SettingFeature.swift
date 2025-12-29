//
//  SettingFeature.swift
//
//  Setting
//
//  Created by JiYeon
//


import Shared
import DesignKit
import ComposableArchitecture
import SettingFeatureInterface
import UserClient
import AuthClient

extension SettingFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    @Dependency(\.openURL) var openURL
    @Dependency(\.userClient) var userClient
    @Dependency(\.authClient) var authClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
        let isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        state.isLoggedIn = isLoggedIn
        if isLoggedIn {
          return .send(.checkUserInfo)
        }
        return .none

      case .checkUserInfo:
        if let username = UserDefaultsKeys.username {
          state.username = username
        }
        return .none

      case .profileTapped:
        return .send(
          state.isLoggedIn ? .delegate(.presentToUpdateProfile) : .delegate(.presentToLogin)
        )

      case .deleteToken:
        return .run { send in
          try await authClient.deleteTokenInfo()
          await send(.checkLoggedIn)
        }

      // MARK: - SettingList Events
      case .settingListTapped(.feedback):
        return .run {
          _ in
          if let url = ExternalURL.feedBack {
            await openURL(url)
          }
        }

      case .settingListTapped(.report):
        return .run { _ in
          if let url = ExternalURL.report {
            await openURL(url)
          }
        }

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
        state.alertType = .logout
        return .none

      case .settingListTapped(.withdraw):
        state.alertType = .withdraw
        return .none

      // MARK: - Alert
      case .alertCancelTapped:
        return .send(.clearAlertState)

      case .alertAcceptTapped(.withdraw):
        return .run { send in
          do {
            let result = try await userClient.withdrawUser()
            print(result.message)
          } catch { }
          await send(.deleteToken)
          await send(.clearAlertState)
        }

      case .alertAcceptTapped(.logout):
        return .run { send in
          do {
            let result = try await authClient.logout()
            print(result.message)
          } catch { }
          await send(.deleteToken)
          await send(.clearAlertState)
        }

      case .clearAlertState:
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
  }
}
