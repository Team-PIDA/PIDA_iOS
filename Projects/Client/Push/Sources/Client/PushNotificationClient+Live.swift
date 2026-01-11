//
//  PushNotificationClient+Live.swift
//  PushClient
//
//  Created by Claude on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging
import ComposableArchitecture

extension PushNotificationClient: DependencyKey {
  public static var liveValue: PushNotificationClient {
    return .init(
      checkAuthorizationStatus: {
        await UNUserNotificationCenter.current()
          .notificationSettings()
          .authorizationStatus
      },
      requestAuthorization: {
        do {
          let granted = try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])

          if granted {
            await MainActor.run {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }

          return granted
        } catch {
          print("❌ 푸시 권한 요청 실패: \(error)")
          return false
        }
      },
      getFCMToken: {
        do {
          let token = try await Messaging.messaging().token()
          return token
        } catch {
          print("❌ FCM 토큰 조회 실패: \(error)")
          return nil
        }
      },
      openSettings: {
        await MainActor.run {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        }
      }
    )
  }
}
