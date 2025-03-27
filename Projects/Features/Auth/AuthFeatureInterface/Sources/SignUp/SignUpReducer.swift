//
//  SignUpReducer.swift
//  AuthFeatureInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import ComposableArchitecture
import AuthDomainInterface

@Reducer
public struct SignUpReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var nickname: String = ""
    public var focusKeyboard: Bool = false
    public var isValidInput: Bool = true
    public var inputValid: NickNameInputValid = .none
    public var email: String? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    case confirmTapped
    case checkValidNickName(String)
    
    case receiveEmail(email: String?)
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
  
  public func nicknameMessage(nickname: String) -> NickNameInputValid {
    if nickname.count < 2 {
      return .tooShort
    } else if nickname.count > 12 {
      return .tooLong
    } else {
      return .valid
    }
  }
  
}

