//
//  MemoryStorage.swift
//  Cache
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation

// MARK: - MemoryStorage

/// 메모리 기반 캐시 저장소
///
/// 딕셔너리를 사용한 인메모리 캐시입니다.
/// 앱이 종료되면 데이터가 사라지지만, 가장 빠른 접근 속도를 제공합니다.
///
/// ## 특징
/// - **빠른 속도**: O(1) 조회/저장
/// - **휘발성**: 앱 종료 시 데이터 손실
/// - **동시성 안전**: `actor`로 구현되어 thread-safe
///
/// ## 사용처
/// - `TwoTierStorage`의 1차 캐시로 사용
/// - 직접 사용하지 말고 `CacheClient`를 통해 접근
///
/// - Note: 이 클래스는 내부 구현이므로 직접 사용하지 마세요.
actor MemoryStorage {

  /// 캐시 데이터를 저장하는 딕셔너리
  private var storage: [String: DataCacheEntry] = [:]

  // MARK: - CRUD Operations

  /// 키에 해당하는 캐시 엔트리 조회
  func get(key: String) -> DataCacheEntry? {
    storage[key]
  }

  /// 캐시 엔트리 저장
  func set(key: String, entry: DataCacheEntry) {
    storage[key] = entry
  }

  /// 특정 키 삭제
  func remove(key: String) {
    storage.removeValue(forKey: key)
  }

  /// 모든 캐시 삭제
  func removeAll() {
    storage.removeAll()
  }

  // MARK: - Utility

  /// 저장된 모든 키 반환
  func allKeys() -> [String] {
    Array(storage.keys)
  }

  /// 저장된 모든 엔트리 반환 (LRU 정책 적용에 사용)
  func allEntries() -> [String: DataCacheEntry] {
    storage
  }

  /// 만료된 항목 일괄 삭제
  ///
  /// 현재 시간 기준으로 만료된 모든 항목을 제거합니다.
  /// `TwoTierStorage`의 타이머에 의해 주기적으로 호출됩니다.
  func removeExpired() {
    let now = Date()
    let expiredKeys = storage.filter { $0.value.expiration < now }.map(\.key)

    for key in expiredKeys {
      storage.removeValue(forKey: key)
    }
  }
}
