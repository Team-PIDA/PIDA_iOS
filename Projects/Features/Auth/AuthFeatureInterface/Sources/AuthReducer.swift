//
//  AuthReducer.swift
//
//  Auth
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct AuthReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var authCode: String? = nil
    public init() {}
  }

  public enum Action: Equatable {
    case appleLoginButtonTapped
    case appleLoginRespose(String?)
    case appleLoginFailure
    
    case delegate(Delegate)
    case dismiss
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
