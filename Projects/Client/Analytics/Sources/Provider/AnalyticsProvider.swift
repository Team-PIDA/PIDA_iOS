//
//  AnalyticsProvider.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - AnalyticsProvider

/// 분석 도구 추상화 프로토콜 (OCP 준수)
/// 새로운 분석 도구 추가 시 이 프로토콜을 구현
public protocol AnalyticsProvider: Sendable {
  /// SDK 초기화
  func initialize(token: String)

  /// 이벤트 트래킹
  func track(_ event: any AnalyticsEvent)

  /// 사용자 식별
  func identify(userId: String)

  /// 사용자 프로필 설정
  func setUserProperties(_ properties: [String: Any])

  /// 사용자 식별 해제
  func reset()

  /// Super Properties 설정
  func setSuperProperties(_ properties: [String: Any])
}
