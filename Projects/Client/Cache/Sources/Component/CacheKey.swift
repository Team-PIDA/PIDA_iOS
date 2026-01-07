//
//  CacheKey.swift
//  CacheClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

// MARK: - CacheKey

/// 타입 안전한 캐시 키를 정의하는 열거형
///
/// ## 왜 String 대신 enum을 사용하나요?
/// String으로 캐시 키를 관리하면 오타, 중복, 일관성 문제가 발생할 수 있습니다.
/// ```swift
/// // Bad: 오타 발생 가능, 컴파일러가 잡아주지 못함
/// cache.get("user_proifle")  // 오타!
/// cache.get("userProfile")   // 다른 곳에서는 이렇게 씀
/// ```
///
/// enum을 사용하면 컴파일 타임에 검증되고, Xcode 자동완성을 활용할 수 있습니다.
/// ```swift
/// // Good: 자동완성 지원, 오타 불가능
/// cache.get(.userProfile)
/// ```
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.cache) var cache
///
/// // 저장 (기본 TTL 자동 적용)
/// try await cache.set(.userProfile, myProfile)
///
/// // 조회
/// let profile: UserProfile? = await cache.get(.userProfile)
///
/// // 연관값이 있는 경우
/// try await cache.set(.flowerSpotDetail(id: 123), detail)
/// let detail: FlowerSpotDetail? = await cache.get(.flowerSpotDetail(id: 123))
/// ```
///
/// ## 새로운 캐시 키 추가하기
/// 1. 적절한 MARK 섹션에 case 추가
/// 2. `rawValue`에서 고유한 문자열 키 반환
/// 3. `defaultTTL`에서 적절한 만료 시간 설정
public enum CacheKey: Sendable {

  // MARK: - FlowerSpot (꽃 명소)

  /// 전체 꽃 명소 목록
  /// - 지도에 표시할 모든 꽃 명소 데이터
  case allFlowerSpots

  /// 특정 꽃 명소의 상세 정보
  /// - Parameter id: 꽃 명소의 고유 식별자
  case flowerSpotDetail(id: Int)

  // MARK: - Image (이미지)

  /// 원격 이미지 데이터 캐시
  /// - Parameter url: 이미지 URL
  /// - Note: URL을 해시값으로 변환하여 키로 사용
  case remoteImage(url: String)

  // MARK: - Search (검색)

  /// 최근 검색어 목록
  /// - 사용자가 검색한 기록을 저장
  case recentSearches

  /// 특정 검색어에 대한 검색 결과
  /// - Parameter query: 검색어
  /// - Note: 동일한 검색어로 재검색 시 캐시된 결과 반환
  case searchResult(query: String)

  // MARK: - User (사용자)

  /// 사용자 프로필 정보
  case userProfile

  /// 사용자 설정값
  case userSettings

  // MARK: - Custom (확장용)

  /// 미리 정의되지 않은 커스텀 캐시 키
  /// - Parameter key: 고유 식별 문자열
  /// - Warning: 가능하면 새로운 case를 추가하는 것을 권장합니다.
  ///   custom은 임시 사용이나 테스트 목적으로만 사용하세요.
  case custom(String)
}

// MARK: - 내부 저장소용 키 변환

public extension CacheKey {

  /// 실제 저장소(Memory/Disk)에서 사용되는 문자열 키
  ///
  /// 이 값은 내부적으로만 사용되며, 외부에서 직접 사용할 필요가 없습니다.
  /// CacheClient의 get/set 메서드가 자동으로 변환합니다.
  ///
  /// ## 키 네이밍 규칙
  /// - 형식: `{도메인}_{세부항목}_{식별자}`
  /// - 예시: `flowerspot_detail_123`, `search_result_abc123`
  var rawValue: String {
    switch self {
    case .allFlowerSpots:
      return "flowerspot_all"

    case let .flowerSpotDetail(id):
      return "flowerspot_detail_\(id)"

    case let .remoteImage(url):
      return "image_\(url.hashValue)"

    case .recentSearches:
      return "search_recent"

    case let .searchResult(query):
      // 검색어를 해시값으로 변환하여 특수문자/공백 문제 방지
      return "search_result_\(query.hashValue)"

    case .userProfile:
      return "user_profile"

    case .userSettings:
      return "user_settings"

    case let .custom(key):
      return "custom_\(key)"
    }
  }
}

// MARK: - 기본 TTL (Time To Live) 설정

public extension CacheKey {

  /// 각 캐시 키에 적합한 기본 만료 시간
  ///
  /// 데이터의 특성에 따라 적절한 TTL이 자동으로 적용됩니다.
  /// 필요시 `cache.set(.key, value, ttl: .custom)`으로 오버라이드 가능합니다.
  ///
  /// ## TTL 설정 기준
  /// | 데이터 특성 | 권장 TTL | 예시 |
  /// |------------|---------|------|
  /// | 자주 변경됨 | 5~10분 | 검색 결과 |
  /// | 가끔 변경됨 | 1~24시간 | 명소 정보 |
  /// | 거의 변경 안됨 | 7~30일 | 사용자 설정, 검색 기록 |
  var defaultTTL: TTL {
    switch self {
    case .allFlowerSpots:
      // 전체 목록은 1시간마다 갱신 (새 명소 추가 반영)
      return .hours(1)

    case .flowerSpotDetail:
      // 상세 정보도 1시간 캐시 (개화 상태 변경 가능)
      return .hours(1)

    case .remoteImage:
      // 이미지는 7일 캐시 (거의 변경되지 않음)
      return .days(7)

    case .recentSearches:
      // 검색 기록은 오래 보관 (30일)
      return .days(30)

    case .searchResult:
      // 검색 결과는 짧게 캐시 (10분) - 결과가 자주 바뀔 수 있음
      return .minutes(10)

    case .userProfile:
      // 프로필은 하루 캐시
      return .hours(24)

    case .userSettings:
      // 설정은 일주일 캐시 (거의 안 바뀜)
      return .days(7)

    case .custom:
      // 커스텀 키는 중간 값 (1시간)
      return .medium
    }
  }
}
