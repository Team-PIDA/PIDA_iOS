//
//  MemoryCacheStorage.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

// MARK: - Memory Cache <- 우선순위 높음
actor MemoryCacheStorage<Key: Hashable, Value: Codable & Sendable>: CacheStorage {
  private var storage: [Key: CacheEntry<Value>] = [:]
  
  init() {}
  
  func store(
    _ entry: CacheEntry<Value>,
    forKey key: Key
  ) async throws {
    storage[key] = entry
  }
  
  func retrieve(
    forKey key: Key
  ) async throws -> CacheEntry<Value>? {
    guard let entry = storage[key] else { return nil }
    return entry.isExpired ? nil : entry
  }
  
  func remove(
    forKey key: Key
  ) async throws {
    storage.removeValue(forKey: key)
  }
  
  func removeAll() async throws {
    storage.removeAll()
  }
  
  func removeExpired() async throws {
    let now = Date()
    let expiredKeys = storage.filter {
      $0.value.expiration < now
    }.map { $0.key } // expired 되어야하는 Cache의 key를 모아둔다.
    
    for key in expiredKeys {
      storage.removeValue(forKey: key) 
    }
  }
  
  func allKeys() async throws -> [Key] {
    return Array(storage.keys)
  }
}
