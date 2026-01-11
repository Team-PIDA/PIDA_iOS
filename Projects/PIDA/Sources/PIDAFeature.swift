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

import PushClient
import UserClient
import DeepLinkClient
import Shared

enum Path: Hashable {
  case setting
  case policy
  case update
}

enum LoginSource: Equatable {
  case setting
  case flowerSpotDetail(spotId: Int)
}

@Reducer
struct PIDAFeature {
  @Dependency(\.pushNotificationClient) var pushNotificationClient
  @Dependency(\.userClient) var userClient

  let locationReducer = Reduce(LocationFeature())
  
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

    /// 네비게이션 이동 경로
    var path: [Path] = []
    var isShowSearch: Bool = false
    var isPresentAuth: Bool = false
    var isPresentSignUp: Bool = false
    var isPresentBlooming: Bool = false
    var loginSource: LoginSource? = nil

    /// 구독 상태 플래그 (중복 구독 방지)
    var isSubscribed: Bool = false
  }

  /// Effect 취소를 위한 ID
  enum CancelID: Hashable {
    case fcmTokenSubscription
    case deepLinkSubscription
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

    case binding(BindingAction<State>)
    case presentSearch(Bool, keyword: String?)
    case presentBloomingUpdate(Bool, id: Int?, streetName: String)
    case presentToLogin(Bool)
    case presentSignUp(Bool)

    // onDismiss cleanup actions (fullScreenCover용)
    case cleanupSearch
    case cleanupBlooming
    case cleanupAuth
    case cleanupSignUp

    // FCM 관련
    case onAppear
    case subscribeFCMToken
    case fcmTokenReceived(String)
    case sendFCMTokenToServer(String)
    case sendFCMTokenIfNeeded

    // DeepLink 관련
    case subscribeDeepLink
    case deepLinkReceived(DeepLink)
    case processPendingDeepLink
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.map, action: \.map) {
      MapFeature(
        location: locationReducer,
        flowerSpotDetail: FlowerSpotDetailFeature()
      )
    }
    Reduce<State, Action> { state, action in
      switch action {
        // MARK: - App Lifecycle

      case .onAppear:
        // 이미 구독 중이면 중복 구독 방지
        guard !state.isSubscribed else { return .none }
        state.isSubscribed = true
        return initializeAppLifecycle()

      case .subscribeFCMToken:
        return subscribeFCMToken()

      case let .fcmTokenReceived(token):
        // 로그인된 경우에만 서버로 토큰 전송
        guard UserDefaultsKeys.accessToken != nil else { return .none }
        return .send(.sendFCMTokenToServer(token))

      case let .sendFCMTokenToServer(token):
        return sendFCMTokenToServer(token: token)

      case .sendFCMTokenIfNeeded:
        return sendFCMTokenIfNeeded()

      case .subscribeDeepLink:
        return subscribeDeepLink()

      case let .deepLinkReceived(deepLink):
        switch deepLink {
        case let .flowerSpotDetail(spotId):
          // 꽃 명소 상세 화면으로 이동 (위치 이동은 detailResponse에서 처리)
          return .send(.map(.fetchDetailInfo(spotId)))
        }

      case .processPendingDeepLink:
        // Cold Start에서 푸시 알림으로 앱 실행 시 pending 딥링크 처리
        guard let pendingDeepLink = AppDelegate.pendingDeepLink else {
          print("📭 No pending DeepLink")
          return .none
        }
        print("✅ Processing pending DeepLink: \(pendingDeepLink)")
        AppDelegate.pendingDeepLink = nil
        return .send(.deepLinkReceived(pendingDeepLink))

        // MARK: - Map <-> Search

      case let .presentSearch(isShow, keyword):
        if isShow {
          state.search = .init(initText: keyword)
        }
        state.isShowSearch = isShow
        return .none

      case let .presentBloomingUpdate(isPresent, id, streetName):
        if isPresent {
          state.blooming = .init(spotId: id, streetName: streetName)
        }
        state.isPresentBlooming = isPresent
        return .none

      case let .presentToLogin(isPresent):
        if isPresent {
          state.auth = .init()
        }
        state.isPresentAuth = isPresent
        return .none

      case let .presentSignUp(isPresent):
        if isPresent {
          state.signUp = .init()
        }
        state.isPresentSignUp = isPresent
        return .none

        // MARK: - Cleanup Actions (called from onDismiss)

      case .cleanupSearch:
        state.search = nil
        return .none

      case .cleanupBlooming:
        state.blooming = nil
        return .none

      case .cleanupAuth:
        state.auth = nil
        return .none

      case .cleanupSignUp:
        state.signUp = nil
        return .none

        // map -> search
      case let .map(.delegate(.presentToSearch(keyword))):
        return .send(.presentSearch(true, keyword: keyword))

        // search dismiss
      case .search(.delegate(.dismiss)):
        return .send(.presentSearch(false, keyword: nil))

        // search dismiss with result
      case let .search(.delegate(.selectResult(result))):
        return .concatenate(
          .send(.map(.showSearchResult(result))),
          .send(.presentSearch(false, keyword: nil))
        )
        
        // MARK: - Blooming Delegate

      case let .blooming(.delegate(.dismiss(didUpdate, spotId))):
        if didUpdate {
          return .concatenate(
            .send(.presentBloomingUpdate(false, id: nil, streetName: "")),
            .send(.map(.fetchDetailInfo(spotId))),
            .send(.map(.flowerSpotDetail(.showToastView(message: "오늘의 개화 상태가 기록되었습니다."))))
          )
        } else {
          return .send(.presentBloomingUpdate(false, id: nil, streetName: ""))
        }

        // MARK: - Map Delegate

      case let .map(.delegate(.presentToBlooming(id, streetName))):
        return .send(.presentBloomingUpdate(true, id: id, streetName: streetName))

      case let .map(.delegate(.presentToLogin(id))):
        state.loginSource = .flowerSpotDetail(spotId: id)
        return .concatenate(
          .send(.presentToLogin(true)),
          .send(.auth(.setSpotId(id: id)))
        )

      case .map(.delegate(.mapDidLoad)):
        // 지도 로드 완료 후 pending 딥링크 처리
        return .send(.processPendingDeepLink)

        // MARK: - Map <-> Setting

        // map -> setting
      case .map(.delegate(.pushToSetting)):
        state.setting = .init()
        state.path.append(.setting)
        return .none
        
      case .setting(.delegate(.pop)):
        state.path.removeLast()
        return .none

        // MARK: - Setting

      case let .setting(.delegate(.pushToPolicy(type))):
        state.policy = .init(type: type)
        state.path.append(.policy)
        return .none

      case .setting(.delegate(.presentToLogin)):
        state.loginSource = .setting
        return .send(.presentToLogin(true))

      case .setting(.delegate(.presentToUpdateProfile)):
        state.update = .init()
        state.path.append(.update)
        return .none

      case .policy(.delegate(.pop)):
        state.path.removeLast()
        return .none

      case .update(.delegate(.pop)):
        state.path.removeLast()
        return .send(.setting(.checkLoggedIn))

        // MARK: - Auth

      case .auth(.delegate(.dismiss)):
        let source = state.loginSource
        state.loginSource = nil
        if case .setting = source {
          return .concatenate(
            .send(.sendFCMTokenIfNeeded),
            .send(.presentToLogin(false)),
            .send(.setting(.checkLoggedIn))
          )
        } else {
          return .concatenate(
            .send(.sendFCMTokenIfNeeded),
            .send(.presentToLogin(false))
          )
        }

      case let .auth(.delegate(.dismissWithVerifyBloomState(id))):
        return .concatenate(
          .send(.sendFCMTokenIfNeeded),
          .send(.presentToLogin(false)),
          .send(.map(.fetchDetailInfo(id)))
        )

      case .auth(.delegate(.presentToSignUp)):
        return .concatenate(
          .send(.presentSignUp(true)),
          .send(.presentToLogin(false))
        )

      case .signUp(.delegate(.dismiss)):
        let source = state.loginSource
        state.loginSource = nil
        if case .setting = source {
          return .concatenate(
            .send(.sendFCMTokenIfNeeded),
            .send(.presentSignUp(false)),
            .send(.setting(.checkLoggedIn))
          )
        } else {
          return .concatenate(
            .send(.sendFCMTokenIfNeeded),
            .send(.presentSignUp(false))
          )
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
          .blooming:
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
  }
}

// MARK: - Private Effects

extension PIDAFeature {
  /// 앱 시작 시 푸시 알림 권한 요청 및 구독 초기화
  private func initializeAppLifecycle() -> Effect<Action> {
    return .run { [pushNotificationClient] send in
      // 푸시 알림 권한 요청
      let status = await pushNotificationClient.checkAuthorizationStatus()
      if status == .notDetermined {
        _ = await pushNotificationClient.requestAuthorization()
      }
      // FCM 토큰 구독 시작
      await send(.subscribeFCMToken)
      // DeepLink 구독 시작
      await send(.subscribeDeepLink)
    }
  }

  /// FCM 토큰 수신 구독
  private func subscribeFCMToken() -> Effect<Action> {
    return .run { send in
      for await notification in NotificationCenter.default.notifications(named: .didReceiveFCMToken) {
        if let token = notification.userInfo?["token"] as? String {
          await send(.fcmTokenReceived(token))
        }
      }
    }
    .cancellable(id: CancelID.fcmTokenSubscription)
  }

  /// FCM 토큰을 서버로 전송 (최대 3회 재시도, 지수 백오프)
  private func sendFCMTokenToServer(token: String) -> Effect<Action> {
    return .run { [userClient] _ in
      for attempt in 1...3 {
        do {
          try await userClient.updateFCMToken(token)
          print("✅ FCM 토큰 서버 전송 성공")
          return
        } catch {
          print("❌ FCM 토큰 서버 전송 실패 (시도 \(attempt)/3): \(error)")
          if attempt < 3 {
            // 지수 백오프: 1초, 2초, 4초
            try? await Task.sleep(for: .seconds(pow(2.0, Double(attempt - 1))))
          }
        }
      }
    }
  }

  /// 로그인 성공 후 현재 FCM 토큰을 가져와 서버로 전송
  private func sendFCMTokenIfNeeded() -> Effect<Action> {
    return .run { [pushNotificationClient] send in
      if let token = await pushNotificationClient.getFCMToken() {
        await send(.sendFCMTokenToServer(token))
      }
    }
  }

  /// DeepLink 이벤트 구독
  private func subscribeDeepLink() -> Effect<Action> {
    return .run { send in
      for await notification in NotificationCenter.default.notifications(named: .didReceiveDeepLink) {
        if let deepLink = notification.userInfo?["deepLink"] as? DeepLink {
          await send(.deepLinkReceived(deepLink))
        }
      }
    }
    .cancellable(id: CancelID.deepLinkSubscription)
  }
}
