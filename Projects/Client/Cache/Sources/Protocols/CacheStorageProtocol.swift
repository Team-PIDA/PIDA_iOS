//
//  CacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 저장소 프로토콜
public protocol CacheStorage<Key, Value> {
  associatedtype Key: Hashable
  associatedtype Value: Codable & Sendable
  
  func store(_ entry: CacheEntry<Value>, forKey key: Key) async throws /// 값 저장
  func retrieve(forKey key: Key) async throws -> CacheEntry<Value>? /// 값 조회
  func remove(forKey key: Key) async throws /// 항목 제거
  func removeAll() async throws /// 모든 항목 제거
  func removeExpired() async throws /// 만료된 항목 제거
  func allKeys() async throws -> [Key]  /// 저장된 모든 키 조회
}
