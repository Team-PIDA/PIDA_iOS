//
//  AnalyticsClient.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import ComposableArchitecture
import Foundation

// MARK: - AnalyticsClient

@DependencyClient
public struct AnalyticsClient: Sendable {
  /// SDK 초기화 (AppDelegate에서 호출)
  public var initialize: @Sendable (_ token: String) -> Void

  /// 이벤트 트래킹
  public var track: @Sendable (_ event: any AnalyticsEvent) -> Void

  /// 사용자 식별 (로그인 시)
  public var identify: @Sendable (_ userId: String) -> Void

  /// 사용자 프로필 업데이트
  public var setUserProperties: @Sendable (_ properties: [String: Any]) -> Void

  /// 사용자 식별 해제 (로그아웃 시)
  public var reset: @Sendable () -> Void

  /// Super Properties 설정 (모든 이벤트에 자동 포함)
  public var setSuperProperties: @Sendable (_ properties: [String: Any]) -> Void
}

// MARK: - DependencyValues

public extension DependencyValues {
  var analyticsClient: AnalyticsClient {
    get { self[AnalyticsClient.self] }
    set { self[AnalyticsClient.self] = newValue }
  }
}
