//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import ComposableArchitecture
import DesignKit

@Reducer
public struct SettingReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var isLoggedIn: Bool = false
    public var username: String = ""
    public var isAlertShow: Bool = false
    public var alertType: AlertType? = nil
    public var isNeedUpdate: Bool = false
    public var version: String = ""
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkVersion
    case configVersionInfo(String, Bool)
    case checkLoggedIn
    case checkUserInfo
    case deleteToken
    
    case feedBackTapped
    case profileTapped
    case settingListTapped(SettingType)
    case alertCancelTapped
    case alertAcceptTapped(AlertType)
    case clearAlertState
    
    case delegate(Delegate)
    case pop
  }
  
  
  public enum Delegate: Equatable {
    case pop
    case pushToPolicy(PolicyType)
    case presentToLogin
    case presentToUpdateProfile
  }
  

  public var body: some ReducerOf<Self> {
    reducer
  }
}
