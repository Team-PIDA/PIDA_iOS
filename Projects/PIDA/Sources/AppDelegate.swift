//
//  AppDelegate.swift
//  PIDA
//
//  Created by Claude on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import Shared

final class AppDelegate: NSObject, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    // MARK: - Firebase 초기 설정
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()

    // MARK: - 푸시 알림 설정
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self

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

  /// 알림 배너를 탭했을 때 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    let userInfo = response.notification.request.content.userInfo
    print("🔔 Push notification tapped: \(userInfo)")

    // TODO: Step 8에서 DeepLinkClient를 통해 처리
  }
}
