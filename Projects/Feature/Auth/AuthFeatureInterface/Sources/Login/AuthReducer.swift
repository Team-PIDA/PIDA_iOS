//
//  AuthReducer.swift
//
//  Auth
//
//  Created by JiYeon
//

import Shared
import ComposableArchitecture

@Reducer
public struct AuthReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var loginInfo: AppleLoginResult? = nil
    public var spotId: Int? = nil
    public init() {}
  }

  public enum Action: Equatable {
    case appleLoginButtonTapped
    case appleLoginRequest
    case appleLoginResponse(AppleLoginResult)
    case appleLoginFailure
    case fetchUserInfo
    case setSpotId(id: Int)
    case delegate(Delegate)
    case dismiss
    case dismissWithVerifyBloomState(id: Int)
    case presentToSignUp
  }
  
  public enum Delegate: Equatable {
    case dismiss
    case dismissWithVerifyBloomState(id: Int)
    case presentToSignUp
  }
  
  public enum ID: Hashable {
    case throttle
  }

  public var body: some ReducerOf<Self> {
    reducer
  }
}
