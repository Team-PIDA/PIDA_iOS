//
//  NotificationName+.swift
//  Shared
//
//  Created by 조용인 on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public extension Notification.Name {
  /// FCM 토큰이 갱신되었을 때 발송되는 노티피케이션
  /// - userInfo: ["token": String]
  static let didReceiveFCMToken = Notification.Name("didReceiveFCMToken")

  /// 딥링크 이벤트가 발생했을 때 발송되는 노티피케이션
  /// - userInfo: ["deepLink": DeepLink]
  static let didReceiveDeepLink = Notification.Name("didReceiveDeepLink")
}
