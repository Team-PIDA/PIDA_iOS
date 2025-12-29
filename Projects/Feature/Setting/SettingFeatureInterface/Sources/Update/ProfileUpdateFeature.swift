//
//  ProfileUpdateFeature.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared

@Reducer
public struct ProfileUpdateFeature {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var nickname: String = ""
    public var changeName: String = ""
    public var focusKeyboard: Bool = false
    public var isLoading: Bool = false
    public var inputValid: NickNameInputValid = .none
    public var isValidInput: Bool = false
    public var toastMessage: String? = nil
    public init(){}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showToastView(message: String?)
    
    case saveTapped
    case isLoading(Bool)
    case checkValidNickName(String)
    case showKeyboard(Bool)
    case changeNickName(String)
    case nicknameValidMessage(NickNameInputValid)
    
    case delegate(Delegate)
    case pop
  }
  
  public enum Delegate {
    case pop
  }
  
  public enum ID: Hashable {
    case throttle
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
  
}
