//
//  ProfileUpdateReducer.swift
//  SettingDemo
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Utility

@Reducer
public struct ProfileUpdateReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var nickname: String = ""
    public var changeName: String = ""
    public var focusKeyboard: Bool = false
    public var inputValid: NickNameInputValid = .none
    public var isValidInput: Bool = false
    public init(){}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case saveTapped
    case checkValidNickName(String)
    case showKeyboard(Bool)
    
    case delegate(Delegate)
    case pop
  }
  
  public enum Delegate {
    case pop
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
  
}
