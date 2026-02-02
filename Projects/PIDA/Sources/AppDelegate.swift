//
//  AppDelegate.swift
//  PIDA
//
//  Created by 조용인 on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import ComposableArchitecture
import Shared
import DeepLinkClient
import AnalyticsClient

final class AppDelegate: NSObject, UIApplicationDelegate {

  /// 앱 시작 시 처리해야 할 딥링크 (cold start에서 푸시 탭 시)
  static var pendingDeepLink: DeepLink?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    // MARK: - Firebase 초기 설정
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()

    // MARK: - Mixpanel 초기화
    if let mixpanelToken = Constant.mixpanel_token {
      @Dependency(\.analyticsClient) var analyticsClient
      analyticsClient.initialize(mixpanelToken)
    }

    // MARK: - 푸시 알림 설정
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self

    // MARK: - Cold Start에서 푸시 알림으로 앱 실행 시 딥링크 저장 (legacy)
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any],
       let deepLink = DeepLink.from(userInfo: remoteNotification) {
      AppDelegate.pendingDeepLink = deepLink
      print("📌 DeepLink saved from launchOptions")
    }

    return true
  }

  // MARK: - APNs 토큰이 등록되었을 때 호출
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("✅ APNs token: \(tokenString)")
  }

  // MARK: - APNs 토큰 등록 실패
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ APNs 등록 실패: \(error.localizedDescription)")
  }

  // MARK: - SceneDelegate 연결
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    config.delegateClass = SceneDelegate.self
    return config
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  /// FCM 토큰이 갱신되었을 때 호출
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else { return }
    print("🔔 FCM token: \(token)")

    NotificationCenter.default.post(
      name: .didReceiveFCMToken,
      object: nil,
      userInfo: ["token": token]
    )
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  /// 포그라운드에서 알림 수신 시 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .badge]
  }

  /// 알림 배너를 탭했을 때 처리 (앱이 실행 중일 때만 호출됨)
  /// Cold start 시에는 SceneDelegate.scene(_:willConnectTo:options:)에서 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    let userInfo = response.notification.request.content.userInfo
    print("🔔 [AppDelegate] Push notification tapped: \(userInfo)")

    guard let deepLink = DeepLink.from(userInfo: userInfo) else { return }

    // 앱이 이미 실행 중(active/inactive)이면 NotificationCenter로 즉시 발송
    // Cold start는 SceneDelegate에서 처리하므로 여기서는 warm state만 처리
    NotificationCenter.default.post(
      name: .didReceiveDeepLink,
      object: nil,
      userInfo: ["deepLink": deepLink]
    )
    print("📤 [AppDelegate] DeepLink sent via NotificationCenter")
  }
}
