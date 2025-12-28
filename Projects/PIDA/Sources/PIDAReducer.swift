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

import BloomingFeature
import BloomingFeatureInterface

import FlowerSpotDetailFeature
import FlowerSpotDetailFeatureInterface

enum Path: Hashable {
  case setting
  case policy
  case update
}

@Reducer
struct PIDAReducer {
  
  @ObservableState
  struct State: Equatable {
    var map = MapFeature.State()
    var search = SearchFeature.State()
    var setting = SettingFeature.State()
    var policy = PolicyFeature.State()
    var auth = AuthFeature.State()
    var signUp = SignUpFeature.State()
    var update = ProfileUpdateFeature.State()
    var blooming = BloomingUpdateFeature.State()
    var flowerSpotDetail = FlowerSpotDetailFeature.State()
    
    /// 네비게이션 이동 경로
    var path: [Path] = []
    var isShowSearch: Bool = false
    var isPresentAuth: Bool = false
    var isPresentSignUp: Bool = false
    var isPresentBlooming: Bool = false
    var isPresentFlowerSpotDetail: Bool = false
  }
  
  enum Action: BindableAction {
    case map(MapFeature.Action)
    case search(SearchFeature.Action)
    case setting(SettingFeature.Action)
    case policy(PolicyFeature.Action)
    case auth(AuthFeature.Action)
    case signUp(SignUpFeature.Action)
    case update(ProfileUpdateFeature.Action)
    case blooming(BloomingUpdateFeature.Action)
    case flowerSpotDetail(FlowerSpotDetailFeature.Action)
    
    case binding(BindingAction<State>)
    case presentSearch(Bool)
    case presentFlowerSpotDetail(Bool)
    case presentBloomingUpdate(Bool)
    case presentToLogin(Bool)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.map, action: \.map) {
      MapFeature()
    }
    Scope(state: \.search, action: \.search) {
      SearchFeature()
    }
    Scope(state: \.setting, action: \.setting) {
      SettingFeature()
    }
    Scope(state: \.policy, action: \.policy) {
      PolicyFeature()
    }
    Scope(state: \.auth, action: \.auth) {
      AuthFeature()
    }
    Scope(state: \.signUp, action: \.signUp) {
      SignUpFeature()
    }
    Scope(state: \.update, action: \.update) {
      ProfileUpdateFeature()
    }
    Scope(state: \.blooming, action: \.blooming) {
      BloomingUpdateFeature()
    }
    Scope(state: \.flowerSpotDetail, action: \.flowerSpotDetail) {
      FlowerSpotDetailFeature()
    }
    
    Reduce {
      state,
      action in
      switch action {
        // MARK: - Map <-> Search
        
      case let .presentSearch(isShow):
        state.isShowSearch = isShow
        return .none
      case let .presentFlowerSpotDetail(isPresent):
        state.isPresentFlowerSpotDetail = isPresent
        return .none
      case let .presentBloomingUpdate(isPresent):
        state.isPresentBlooming = isPresent
        return .none
      case let .presentToLogin(isPresent):
        state.isPresentAuth = isPresent
        return .none
        // map -> search
      case let .map(.delegate(.presentToSearch(keyword))):
        
        return .run { send in
          await MainActor.run {
            send(.search(.initialSearchBar(keyword)))
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
        
        // MARK: - Spot Detail
        
      case let .map(
        .delegate(
          .presentToDetail(
            flowerSpotData,
            bloomingData,
            distance,
            isVotedBlooming
          )
        )
      ):
        // TODO: - 상세화면연결 및 flowerSpotData 전달
        return .run { send in
          await MainActor.run {
            send(.flowerSpotDetail(.setFlowerSpotData(flowerSpotData)))
            send(.flowerSpotDetail(.setBloomingStatus(bloomingData)))
            send(.flowerSpotDetail(.setDistance(distance)))
            send(.flowerSpotDetail(.setVerifyBloomingStatus(isVotedBlooming)))
            send(.presentFlowerSpotDetail(true))
          }
        }
      case .flowerSpotDetail(.delegate(.dismiss)):
        return .send(.presentFlowerSpotDetail(false))
        
      case let .flowerSpotDetail(.delegate(.presentToBlooming(id, streetName))):
        return .run { send in
          await MainActor.run {
            send(.blooming(.setSpodtId(id)))
            send(.blooming(.setStreetName(streetName)))
            send(.presentBloomingUpdate(true))
          }
        }
      case let .flowerSpotDetail(.delegate(.presentToLogin(id))):
        return .run { send in
          await MainActor.run {
            send(.presentToLogin(true))
            send(.auth(.setSpotId(id: id)))
          }
        }
      case let .blooming(.delegate(.dismiss(didUpdate, spotId))):
        return .run { send in
          await send(.presentBloomingUpdate(false))
          if didUpdate {
            await send(.map(.fetchDetailInfo(spotId)))
            try? await Task.sleep(for: .seconds(0.3))
            await send(.flowerSpotDetail(.showToastView(message: "오늘의 개화 상태가 기록되었습니다.")))
          }
        }
        
        // MARK: - Map <-> Setting
        
        // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.path.append(.setting)
        return .none
        
      case .setting(.delegate(.pop)):
        state.path.removeLast()
        return .none
        
        // MARK: - Setting
        
      case let .setting(.delegate(.pushToPolicy(type))):
        state.policy.type = type
        state.path.append(.policy)
        return .none
        
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
            send(.presentToLogin(false))
            send(.setting(.checkLoggedIn))
          }
        }
      case let .auth(.delegate(.dismissWithVerifyBloomState(id))):
        return .run { send in
          await MainActor.run {
            send(.presentToLogin(false))
            send(.map(.fetchDetailInfo(id)))
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
        
      case .binding, .map, .search, .setting, .policy, .auth, .signUp, .update, .blooming, .flowerSpotDetail:
        return .none
      }
    }
    
  }
}
