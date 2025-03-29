//
//  PIDAReducer.swift
//  PIDA
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture

import MapFeature
import MapFeatureInterface

import SearchFeature
import SearchFeatureInterface

import SettingFeature
import SettingFeatureInterface

import AuthFeature
import AuthFeatureInterface

enum Path: Hashable {
  case setting
  case policy
  case update
}

@Reducer
struct PIDAReducer {
  
  @ObservableState
  struct State: Equatable {
    var map = MapReducer.State()
    var search = SearchReducer.State()
    var setting = SettingReducer.State()
    var policy = PolicyReducer.State()
    var auth = AuthReducer.State()
    var signUp = SignUpReducer.State()
    var update = ProfileUpdateReducer.State()
    
    /// 네비게이션 이동 경로
    var path: [Path] = []
    var isShowSearch: Bool = false
    var isPresentAuth: Bool = false
    var isPresentSignUp: Bool = false
  }
  
  enum Action: BindableAction {
    case map(MapReducer.Action)
    case search(SearchReducer.Action)
    case setting(SettingReducer.Action)
    case policy(PolicyReducer.Action)
    case auth(AuthReducer.Action)
    case signUp(SignUpReducer.Action)
    case update(ProfileUpdateReducer.Action)
    
    case binding(BindingAction<State>)
    case presentSearch(Bool)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.map, action: \.map) {
      MapReducer()
    }
    Scope(state: \.search, action: \.search) {
      SearchReducer()
    }
    Scope(state: \.setting, action: \.setting) {
      SettingReducer()
    }
    Scope(state: \.policy, action: \.policy) {
      PolicyReducer()
    }
    Scope(state: \.auth, action: \.auth) {
      AuthReducer()
    }
    Scope(state: \.signUp, action: \.signUp) {
      SignUpReducer()
    }
    Scope(state: \.update, action: \.update) {
      ProfileUpdateReducer()
    }
    
    Reduce { state, action in
      switch action {
        // MARK: - Map <-> Search
        
      case let .presentSearch(isShow):
        state.isShowSearch = isShow
        return .none
        
        // map -> search
      case .map(.delegate(.presentToSearch)):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(true))
          }
        }
        // 검색 후 main에서 뒤로가기 시 search의 searchbar 비우기
      case .map(.delegate(.resetSearchView)):
        return .run { send in
          await MainActor.run {
            send(.search(.initialSearchBar("")))
          }
        }
        // search dismiss
      case .search(.delegate(.dismiss)):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(false))
          }
        }
        
        // search dismiss with result
      case let .search(.delegate(.selectResult(result))):
        return .run { send in
          await MainActor.run {
            send(.map(.showSearchResult(result)))
            send(.presentSearch(false))
          }
        }
        
        // MARK: - Map
        
        // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.path.append(.setting)
        return .none
        
        // MARK: - Setting
      
      case .setting(.delegate(.pop)):
        state.path.removeLast()
        return .none
        
      case let .setting(.delegate(.pushToPolicy(type))):
        state.policy.type = type
        state.path.append(.policy)
        return .none
        
        // setting -> login
        
      case .setting(.delegate(.presentToLogin)):
        state.isPresentAuth = true
        return .none
        
      case .setting(.delegate(.presentToUpdateProfile)):
        state.path.append(.update)
        return .none
        
      case .policy(.delegate(.pop)):
        state.path.removeLast()
        return .none
        
      case .update(.delegate(.pop)):
        state.path.removeLast()
        return .run { send in
          await MainActor.run {
            send(.setting(.checkLoggedIn))
          }
        }
        
        // MARK: - Auth
        
      case .auth(.delegate(.dismiss)):
        state.isPresentAuth = false
        return .run { send in
          await MainActor.run {
            send(.setting(.checkLoggedIn))
          }
        }
        
      case .auth(.delegate(.presentToSignUp)):
        state.isPresentSignUp = true
        state.isPresentAuth = false
        return .none
        
      case .signUp(.delegate(.dismiss)):
        state.isPresentSignUp = false
        return .run { send in
          await MainActor.run {
            send(.setting(.checkLoggedIn))
          }
        }
        
        // MARK: - None
        
      case .binding, .map, .search, .setting, .policy, .auth, .signUp, .update:
        return .none
      }
    }
    
  }
}
