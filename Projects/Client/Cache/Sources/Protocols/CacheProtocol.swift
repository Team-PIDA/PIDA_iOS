//
//  CacheProtocol.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 프로토콜
public protocol Cache<Key, Value> {
  associatedtype Key: Hashable
  associatedtype Value: Codable

  func insert(_ value: Value, forKey key: Key, ttl: TTLScale?) async throws   /// 값 저장
  func value(forKey key: Key) async -> Value?  /// 값 조회
  func remove(forKey key: Key) async  /// 항목 제거
  func removeAll() async  /// 모든 항목 제거
  func startExpirationTimer(interval: TimeInterval) async /// 만료된 항목 제거 시작
}
