//
//  SettingReducer.swift
//
//  Setting
//
//  Created by JiYeon
//

import ComposableArchitecture

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
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case profileTapped
    case feedBackTapped
    
    case settingListTapped(SettingType)
    case alertCancelTapped
    case alertAcceptTapped
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
