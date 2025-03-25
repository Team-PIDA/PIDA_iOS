//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import SettingFeatureInterface
import ComposableArchitecture
import Utility

extension SettingReducer {
  public init() {
    @Dependency(\.openURL) var openURL
    
    let reducer = Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        return .none
      case .feedBackTapped:
        return .run { send in
          if let url = ExternalURL.feedBack {
            await openURL(url)
          }
        }
        
        // MARK: - SettingList Events
        
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
      case .alertAcceptTapped:
        return .send(.clearAlertState)
      case .clearAlertState:
        state.isAlertShow = false
        state.alertType = nil
        return .none
        
        // MARK: - Delegate
        
      case .pop:
        return .send(.delegate(.pop))
        
        // MARK: - None
        
      case .delegate, .settingListTapped, .binding:
        return .none
      }
    }
    self.init(reducer: reducer)
  }
}
