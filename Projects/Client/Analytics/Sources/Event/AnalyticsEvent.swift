//
//  AnalyticsEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - AnalyticsEvent

/// 분석 이벤트 프로토콜 (OCP 준수)
/// 새로운 이벤트 추가 시 이 프로토콜을 준수하는 enum 생성
///
/// - Warning: `properties`는 Sendable 타입만 포함해야 합니다.
///            허용 타입: `String`, `Int`, `Double`, `Bool`, `Date`, `URL`
///            Mixpanel SDK API 제약으로 `[String: Any]`를 사용합니다.
public protocol AnalyticsEvent: Sendable {
  /// 이벤트 이름 (snake_case)
  var name: String { get }

  /// 이벤트 고유 속성 (Super Properties 제외)
  /// - Note: Sendable 타입만 포함해야 합니다.
  var properties: [String: Any] { get }
}

// MARK: - Default Implementation

public extension AnalyticsEvent {
  var properties: [String: Any] { [:] }
}
