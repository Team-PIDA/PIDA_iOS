//
//  CacheClient.swift
//  CacheClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared

// MARK: - CacheClient

/// TCA 의존성 기반 캐시 클라이언트
///
/// Two-Tier 캐싱(메모리 + 디스크)을 추상화한 클라이언트입니다.
/// `@DependencyClient` 매크로를 사용하여 테스트/프리뷰 환경에서 자동으로 목(mock) 구현이 제공됩니다.
///
/// ## 기본 사용법
/// ```swift
/// // Reducer에서 의존성 주입
/// @Dependency(\.cache) var cache
///
/// // 데이터 저장 (CacheKey의 기본 TTL 적용)
/// try await cache.set(.userProfile, userProfile)
///
/// // 데이터 조회
/// let profile: UserProfile? = await cache.get(.userProfile)
///
/// // 데이터 삭제
/// await cache.remove(.userProfile)
///
/// // 전체 캐시 삭제 (로그아웃 시 등)
/// await cache.removeAll()
/// ```
///
/// ## 아키텍처
/// ```
/// CacheClient (인터페이스)
///      ↓
/// TwoTierStorage (구현체)
///      ↓
/// ┌─────────────┬─────────────┐
/// │MemoryStorage│ DiskStorage │
/// │ (1차 캐시)    │ (2차 캐시)    │
/// └─────────────┴─────────────┘
/// ```
///
/// ## 캐시 동작 흐름
/// 1. **조회 시**: 메모리 → (miss) → 디스크 → (miss) → nil 반환
/// 2. **저장 시**: 메모리 + 디스크 동시 저장
/// 3. **만료 처리**: 60초마다 백그라운드에서 자동 정리
///
/// - Note: 제네릭 클로저는 `@DependencyClient` 매크로와 호환되지 않아
///   내부적으로 `Data` 기반 API를 사용하고, 외부에는 타입 안전 편의 메서드를 제공합니다.
@DependencyClient
public struct CacheClient: Sendable {

  // MARK: - 내부 API (Data 기반)
  // 이 프로퍼티들은 @DependencyClient 매크로가 관리합니다.
  // 외부에서는 아래의 CacheKey 기반 편의 메서드를 사용하세요.

  /// 캐시 데이터 조회 (Raw Data)
  /// - Note: 외부에서는 `get(_:as:)` 메서드를 사용하세요.
  var _get: @Sendable (String) async -> Data?

  /// 캐시 데이터 저장 (Raw Data)
  /// - Note: 외부에서는 `set(_:_:)` 또는 `set(_:_:ttl:)` 메서드를 사용하세요.
  var _set: @Sendable (String, Data, TTL) async throws -> Void

  /// 특정 키의 캐시 삭제
  /// - Note: 외부에서는 `remove(_:)` 메서드를 사용하세요.
  var _remove: @Sendable (String) async -> Void

  /// 모든 캐시 삭제
  var _removeAll: @Sendable () async -> Void
}

// MARK: - 타입 안전 Public API (외부 사용용)
public extension CacheClient {

  /// 캐시에서 값을 조회합니다.
  ///
  /// 메모리 캐시를 먼저 확인하고, 없으면 디스크 캐시를 확인합니다.
  /// 디스크에서 찾은 경우 메모리에도 복사하여 다음 조회를 빠르게 합니다.
  ///
  /// ```swift
  /// // 타입 추론 사용
  /// let profile: UserProfile? = await cache.get(.userProfile)
  ///
  /// // 명시적 타입 지정
  /// let spots = await cache.get(.allFlowerSpots, as: [FlowerSpot].self)
  /// ```
  ///
  /// - Parameters:
  ///   - key: 조회할 캐시 키
  ///   - type: 반환받을 타입 (타입 추론 가능)
  /// - Returns: 캐시된 값, 없거나 만료된 경우 `nil`
  func get<Value: Codable & Sendable>(
    _ key: CacheKey,
    as type: Value.Type = Value.self
  ) async -> Value? {
    guard let data = await _get(key.rawValue) else { return nil }
    return try? data.decode(Value.self)
  }

  /// 캐시에 값을 저장합니다. (기본 TTL 사용)
  ///
  /// 각 `CacheKey`에 정의된 기본 TTL이 자동으로 적용됩니다.
  /// 예: `.userProfile`은 24시간, `.searchResult`는 10분
  ///
  /// ```swift
  /// try await cache.set(.userProfile, myProfile)
  /// try await cache.set(.flowerSpotDetail(id: 123), spotDetail)
  /// ```
  ///
  /// - Parameters:
  ///   - key: 저장할 캐시 키
  ///   - value: 저장할 값 (Codable 필수)
  func set<Value: Codable & Sendable>(
    _ key: CacheKey,
    _ value: Value
  ) async throws {
    let data = try JSONEncoder().encode(value)
    try await _set(key.rawValue, data, key.defaultTTL)
  }

  /// 캐시에 값을 저장합니다. (커스텀 TTL 지정)
  ///
  /// 기본 TTL 대신 원하는 만료 시간을 지정할 수 있습니다.
  ///
  /// ```swift
  /// // 5분 후 만료
  /// try await cache.set(.searchResult(query: "벚꽃"), results, ttl: .minutes(5))
  ///
  /// // 즉시 만료 (테스트용)
  /// try await cache.set(.userProfile, profile, ttl: .seconds(0))
  /// ```
  ///
  /// - Parameters:
  ///   - key: 저장할 캐시 키
  ///   - value: 저장할 값
  ///   - ttl: 만료 시간 (Time To Live)
  func set<Value: Codable & Sendable>(
    _ key: CacheKey,
    _ value: Value,
    ttl: TTL
  ) async throws {
    let data = try JSONEncoder().encode(value)
    try await _set(key.rawValue, data, ttl)
  }

  /// 특정 캐시 키를 삭제합니다.
  ///
  /// 메모리와 디스크 모두에서 해당 키의 데이터를 제거합니다.
  ///
  /// ```swift
  /// // 특정 명소 상세 정보 캐시 삭제
  /// await cache.remove(.flowerSpotDetail(id: 123))
  ///
  /// // 사용자 프로필 캐시 삭제
  /// await cache.remove(.userProfile)
  /// ```
  ///
  /// - Parameter key: 삭제할 캐시 키
  func remove(_ key: CacheKey) async {
    await _remove(key.rawValue)
  }
}

// MARK: - TCA DependencyValues 등록
public extension DependencyValues {
  /// 캐시 클라이언트 의존성
  ///
  /// ```swift
  /// @Dependency(\.cache) var cache
  /// ```
  var cache: CacheClient {
    get { self[CacheClient.self] }
    set { self[CacheClient.self] = newValue }
  }
}
