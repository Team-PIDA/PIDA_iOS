//
//  PIDAFeature.swift
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
struct PIDAFeature {
  let locationReducer = Reduce(LocationFeature())
  let detailReducer = Reduce(DetailFeature())
  
  @ObservableState
  struct State: Equatable {
    var map = MapFeature.State()
    var search: SearchFeature.State? = nil
    var setting: SettingFeature.State? = nil
    var policy: PolicyFeature.State? = nil
    var auth: AuthFeature.State? = nil
    var signUp: SignUpFeature.State? = nil
    var update: ProfileUpdateFeature.State? = nil
    var blooming: BloomingUpdateFeature.State? = nil
    var flowerSpotDetail: FlowerSpotDetailFeature.State? = nil
    
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
    case presentSearch(Bool, keyword: String?)
    case presentFlowerSpotDetail(Bool, state: FlowerSpotDetailFeature.State?)
    case presentBloomingUpdate(Bool, id: Int?, streetName: String)
    case presentToLogin(Bool)
    case presentSignUp(Bool)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.map, action: \.map) {
      MapFeature(
        location: locationReducer,
        detail: detailReducer
      )
    }
    Reduce {
      state,
      action in
      switch action {
        // MARK: - Map <-> Search
        
      case let .presentSearch(isShow, keyword):
        state.search = isShow ? .init(initText: keyword) : nil
        state.isShowSearch = isShow
        return .none
        
      case let .presentFlowerSpotDetail(isPresent, flowerSpotDetail):
        state.flowerSpotDetail = flowerSpotDetail
        state.isPresentFlowerSpotDetail = isPresent
        return .none
        
      case let .presentBloomingUpdate(isPresent, id, streetName):
        state.blooming = isPresent ? .init(spotId: id, streetName: streetName) : nil
        state.isPresentBlooming = isPresent
        return .none
        
      case let .presentToLogin(isPresent):
        state.auth = isPresent ? .init() : nil
        state.isPresentAuth = isPresent
        return .none
        
      case let .presentSignUp(isPresent):
        state.signUp = isPresent ? .init() : nil
        state.isPresentSignUp = isPresent
        return .none
        
        // map -> search
      case let .map(.delegate(.presentToSearch(keyword))):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(true, keyword: keyword))
          }
        }
        // search dismiss
      case .search(.delegate(.dismiss)):
        return .run { send in
          await MainActor.run {
            send(.presentSearch(false, keyword: nil))
          }
        }
        
        // search dismiss with result
      case let .search(.delegate(.selectResult(result))):
        return .run { send in
          await MainActor.run {
            send(.map(.showSearchResult(result)))
            send(.presentSearch(false, keyword: nil))
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
        let detailState: FlowerSpotDetailFeature.State = .init(
          flowerSpotData: flowerSpotData,
          bloomingStatus: bloomingData,
          distance: distance,
          isVotedBlooming: isVotedBlooming
        )
        return .run { send in
          await MainActor.run {
            send(.presentFlowerSpotDetail(true, state: detailState))
          }
        }
      case .flowerSpotDetail(.delegate(.dismiss)):
        return .send(.presentFlowerSpotDetail(false, state: nil))
        
      case let .flowerSpotDetail(.delegate(.presentToBlooming(id, streetName))):
        return .run { send in
          await MainActor.run {
            send(.presentBloomingUpdate(true, id: id, streetName: streetName))
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
          await send(.presentBloomingUpdate(false, id: nil, streetName: ""))
          if didUpdate {
            await send(.map(.fetchDetailInfo(spotId)))
            try? await Task.sleep(for: .seconds(0.3))
            await send(.flowerSpotDetail(.showToastView(message: "오늘의 개화 상태가 기록되었습니다.")))
          }
        }
        
        // MARK: - Map <-> Setting
        
        // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.setting = .init()
        state.path.append(.setting)
        return .none
        
      case .setting(.delegate(.pop)):
        state.setting = nil
        state.path.removeLast()
        return .none
        
        // MARK: - Setting
        
      case let .setting(.delegate(.pushToPolicy(type))):
        state.policy = .init(type: type)
        state.path.append(.policy)
        return .none
        
      case .setting(.delegate(.presentToLogin)):
        return .send(.presentToLogin(true))
        
      case .setting(.delegate(.presentToUpdateProfile)):
        state.update = .init()
        state.path.append(.update)
        return .none
        
      case .policy(.delegate(.pop)):
        state.path.removeLast()
        state.update = nil
        return .none
        
      case .update(.delegate(.pop)):
        state.path.removeLast()
        state.update = nil
        return .run { send in
          await MainActor.run {
            send(.setting(.checkLoggedIn))
          }
        }
        
        // MARK: - Auth
        
      case .auth(.delegate(.dismiss)):
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
        return .run { send in
          await MainActor.run {
            send(.presentSignUp(true))
            send(.presentToLogin(false))
          }
        }
        
      case .signUp(.delegate(.dismiss)):
        return .run { send in
          await MainActor.run {
            send(.presentSignUp(false))
            send(.setting(.checkLoggedIn))
          }
        }
        
        // MARK: - None
        
      case .binding,
          .map,
          .search,
          .setting,
          .policy,
          .auth,
          .signUp,
          .update,
          .blooming,
          .flowerSpotDetail:
        return .none
      }
    }
    .subFeatures()
  }
}


extension Reducer where State == PIDAFeature.State, Action == PIDAFeature.Action {
  func subFeatures() -> some ReducerOf<Self> {
    self
      .ifLet(\.search, action: \.search) { SearchFeature() }
      .ifLet(\.setting, action: \.setting) { SettingFeature() }
      .ifLet(\.policy, action: \.policy) { PolicyFeature() }
      .ifLet(\.auth, action: \.auth) { AuthFeature() }
      .ifLet(\.signUp, action: \.signUp) { SignUpFeature() }
      .ifLet(\.update, action: \.update) { ProfileUpdateFeature() }
      .ifLet(\.blooming, action: \.blooming) { BloomingUpdateFeature() }
      .ifLet(\.flowerSpotDetail, action: \.flowerSpotDetail) { FlowerSpotDetailFeature() }
  }
}
