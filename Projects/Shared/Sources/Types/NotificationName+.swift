//
//  NotificationName+.swift
//  Shared
//
//  Created by Claude on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public extension Notification.Name {
  /// FCM 토큰이 갱신되었을 때 발송되는 노티피케이션
  /// - userInfo: ["token": String]
  static let didReceiveFCMToken = Notification.Name("didReceiveFCMToken")
}
