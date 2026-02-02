//
//  SessionEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - SessionEvent

/// 세션 관련 이벤트
public enum SessionEvent: AnalyticsEvent {
  /// 세션 시작, 메인 화면 진입
  case start(
    sessionDuration: Int?,
    sessionPreviousGap: Int?,
    userLocationEnabled: Bool
  )

  public var name: String {
    switch self {
    case .start:
      return "session_start"
    }
  }

  public var properties: [String: Any] {
    switch self {
    case let .start(sessionDuration, sessionPreviousGap, userLocationEnabled):
      var props: [String: Any] = [
        "user_location_enabled": userLocationEnabled
      ]

      if let sessionDuration {
        props["session_duration"] = sessionDuration
      }

      if let sessionPreviousGap {
        props["session_previous_gap"] = sessionPreviousGap
      }

      return props
    }
  }
}
