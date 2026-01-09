//
//  SceneDelegate.swift
//  PIDA
//
//  Created by 조용인 on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import UIKit
import DeepLinkClient
import Shared

final class SceneDelegate: NSObject, UIWindowSceneDelegate {

  var window: UIWindow?

  // MARK: - 앱이 실행될 때(Cold Launch) 호출되는 메서드
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // 푸시 알림으로 앱 시작 (Cold Start)
    if let notificationResponse = connectionOptions.notificationResponse {
      let userInfo = notificationResponse.notification.request.content.userInfo
      print("🔔 [SceneDelegate] Cold start from push notification: \(userInfo)")

      if let deepLink = DeepLink.from(userInfo: userInfo) {
        AppDelegate.pendingDeepLink = deepLink
        print("📌 [SceneDelegate] DeepLink saved as pending: \(deepLink)")
      }
    }
  }
}
