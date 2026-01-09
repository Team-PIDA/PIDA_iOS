//
//  PushNotificationClient.swift
//  PushClient
//
//  Created by Claude on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import UserNotifications
import ComposableArchitecture

@DependencyClient
public struct PushNotificationClient: Sendable {
  /// 현재 푸시 알림 권한 상태 확인
  public var checkAuthorizationStatus: @Sendable () async -> UNAuthorizationStatus = { .notDetermined }

  /// 푸시 알림 권한 요청
  public var requestAuthorization: @Sendable () async -> Bool = { false }

  /// 현재 FCM 토큰 조회
  public var getFCMToken: @Sendable () async -> String? = { nil }

  /// 시스템 설정 열기 (알림 설정)
  public var openSettings: @Sendable () async -> Void = {}
}

public extension DependencyValues {
  var pushNotificationClient: PushNotificationClient {
    get { self[PushNotificationClient.self] }
    set { self[PushNotificationClient.self] = newValue }
  }
}
