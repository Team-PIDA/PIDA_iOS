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
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showKeyboard(Bool)
    
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
}
