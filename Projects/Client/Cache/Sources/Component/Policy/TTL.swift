//
//  TTL.swift
//  CacheClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

// MARK: - TTL (Time To Live)

/// 캐시 만료 시간을 정의하는 열거형
///
/// 캐시된 데이터가 얼마나 오래 유효한지를 지정합니다.
/// 만료된 데이터는 자동으로 삭제되며, 조회 시 `nil`을 반환합니다.
///
/// ## 사용 예시
/// ```swift
/// // 기본 프리셋 사용
/// try await cache.set(.searchResult, data, ttl: .short)   // 5분
/// try await cache.set(.userProfile, data, ttl: .medium)   // 1시간
/// try await cache.set(.userSettings, data, ttl: .long)    // 24시간
///
/// // 커스텀 시간 지정
/// try await cache.set(.customData, data, ttl: .minutes(30))
/// try await cache.set(.tempData, data, ttl: .seconds(10))
/// ```
///
/// ## TTL 선택 가이드
/// | 데이터 특성 | 권장 TTL | 프리셋 |
/// |------------|---------|--------|
/// | 자주 변경되는 데이터 | 5~10분 | `.short` |
/// | 일반적인 캐시 데이터 | 1시간 | `.medium` |
/// | 거의 변경되지 않는 데이터 | 24시간+ | `.long` |
public enum TTL: Sendable {

  /// 초 단위 TTL
  /// - Parameter value: 만료까지의 초
  case seconds(TimeInterval)

  /// 분 단위 TTL
  /// - Parameter value: 만료까지의 분
  case minutes(Int)

  /// 시간 단위 TTL
  /// - Parameter value: 만료까지의 시간
  case hours(Int)

  /// 일 단위 TTL
  /// - Parameter value: 만료까지의 일
  case days(Int)
}

// MARK: - TimeInterval 변환

extension TTL {
  /// 내부적으로 사용되는 초 단위 TimeInterval 값
  var timeInterval: TimeInterval {
    switch self {
    case let .seconds(value):
      return value
    case let .minutes(value):
      return TimeInterval(value * 60)
    case let .hours(value):
      return TimeInterval(value * 3600)
    case let .days(value):
      return TimeInterval(value * 86400)
    }
  }
}

// MARK: - 편의 프리셋

public extension TTL {
  /// 짧은 캐시 (5분)
  /// - 자주 변경되는 데이터에 적합
  /// - 예: 검색 결과, 실시간 정보
  static let short = TTL.minutes(5)

  /// 중간 캐시 (1시간)
  /// - 일반적인 캐시에 적합
  /// - 예: 상세 정보, 목록 데이터
  static let medium = TTL.hours(1)

  /// 긴 캐시 (24시간)
  /// - 거의 변경되지 않는 데이터에 적합
  /// - 예: 사용자 프로필, 설정값
  static let long = TTL.hours(24)
}
