//
//  TwoTierCache.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 메모리와 디스크를 함께 사용하는 2단계 캐시 구현
public actor TwoTierCache<Namespace: CacheNamespace, Value: Codable & Sendable>: Cache {
  public typealias Key = CacheKey<Namespace>
  
  private let memoryStorage: MemoryCacheStorage<Key, Value>
  private let diskStorage: DiskCacheStorage<Namespace, Value>
  private var expirationTimer: Task<Void, Never>?
  
  private let defaultTTL: TTLScale
  private let eviction: EvictionPolicy
  
  public init(
    defaultTTL: TTLScale = .medium,
    eviction: EvictionPolicy = .lru(100),
    cacheName: String
  ) async throws {
    self.defaultTTL = defaultTTL
    self.eviction = eviction
    self.memoryStorage = MemoryCacheStorage()
    self.diskStorage = try DiskCacheStorage(cacheName: cacheName)
    
    await loadFromDisk()
    await startExpirationTimer(interval: 60.0)
  }
  
  deinit { expirationTimer?.cancel() }
  
  /// 디스크에서 캐시 항목 로드
  ///
  /// - Note: `TwoTierCache` 초기화 시, Disk Cache에서 캐시 항목을 로드하여 Memory Cache에 저장합니다.
  private func loadFromDisk() async {
    do {
      let keys = try await diskStorage.allKeys()
      for key in keys {
        if let entry = try await diskStorage.retrieve(forKey: key), !entry.isExpired {
          try await memoryStorage.store(entry, forKey: key) /// Disk Cache에서 조회 성공하면, Memory Cache에 저장
        }
      }
      await applyEvictionIfNeeded() /// 디스크에서 로드한 캐시에 대해 제거 정책 적용
    } catch {
      print("디스크에서 캐시를 로드하는데 실패: \(error)")
    }
  }
  
  /// 제거 정책 적용
  /// - Discussion: 캐시 항목이 제한을 초과하면 제거 정책(`eviction`)에 따라 적절한 항목을 제거합니다.
  ///   - `.lru(maxCount)`: 최근에 사용된 항목을 우선적으로 제거 (메모리에서만)
  ///   - `.fifo(maxCount)`: 먼저 저장된 항목을 우선적으로 제거 (메모리에서만)
  ///   - `.size(maxSize)`: 캐시 크기 제한 (미구현)
  ///   - `.none`: 제거 정책 없음
  private func applyEvictionIfNeeded() async {
    switch eviction {
    case let .lru(maxCount):
      let keys = try? await memoryStorage.allKeys()
      guard let allKeys = keys, allKeys.count > maxCount else { return }
      
      // 모든 항목과 마지막 접근 시간을 가져옴
      var entries: [(key: Key, entry: CacheEntry<Value>)] = []
      for key in allKeys {
        if let entry = try? await memoryStorage.retrieve(forKey: key) {
          entries.append((key, entry))
        }
      }
      
      // 접근 시간 기준 정렬
      let sortedEntries = entries.sorted { $0.entry.lastAccessed < $1.entry.lastAccessed }
      
      // 초과분 제거 (메모리에서만)
      let toRemove = sortedEntries.prefix(entries.count - maxCount)
      for (key, _) in toRemove {
        try? await memoryStorage.remove(forKey: key)
      }
    case let .fifo(maxCount):
      let keys = try? await memoryStorage.allKeys()
      guard let allKeys = keys, allKeys.count > maxCount else { return }
      
      /// 모든 항목과 생성 시간을 가져옴
      var entries: [(key: Key, entry: CacheEntry<Value>)] = []
      for key in allKeys {
        if let entry = try? await memoryStorage.retrieve(forKey: key) {
          entries.append((key, entry))
        }
      }
      
      /// 생성 시간 기준 정렬
      let sortedEntries = entries.sorted { $0.entry.createdAt < $1.entry.createdAt }
      
      /// 초과분 제거 (메모리에서만)
      let toRemove = sortedEntries.prefix(entries.count - maxCount)
      for (key, _) in toRemove {
        try? await memoryStorage.remove(forKey: key)
      }
    case let .size(maxSize): break
    case .none: return
    }
  }
}

// MARK: - Cache 프로토콜 구현
public extension TwoTierCache {
  
  /// `key`에 해당하는 캐시 항목을 저장
  ///
  /// - Parameters:
  ///   - value: 저장할 값 (`Codable` & `Sendable`)
  ///   - key: 저장할 값의 키 (`CacheKey` -> `Namespace`로 구분)
  ///   - ttl: 캐시 유지 시간 (기본값: `defaultTTL`)
  ///
  /// - Note: Memory Cache -> Disk Cache 순서로 저장하며, 저장 이후 제거 정책(Eviction Policy)을 적용함
  func insert(
    _ value: Value,
    forKey key: Key,
    ttl: TTLScale? = nil
  ) async throws {
    let ttlValue = ttl ?? defaultTTL
    let expiration = Date().addingTimeInterval(ttlValue.timeInterval)
    let entry = CacheEntry(value: value, expiration: expiration)
    
    try await memoryStorage.store(entry, forKey: key) // 1. 우선 Memory Cache에 저장
    try await diskStorage.store(entry, forKey: key)   // 2. 추가적으로 Disk Cache에 저장
    await applyEvictionIfNeeded()                     // 3. 제거 정책 적용
  }
  
  /// Memory Cache -> Disk Cache 순서로 확인하며, 캐시 항목 반환 (Cache Miss 시 nil 반환)
  ///
  /// - Parameters:
  ///   - key: 캐시 항목을 찾기 위한 키
  ///
  /// - Note: Memory Cache -> Disk Cache 순서로 확인하며, Cache Miss 시 nil 반환
  func value(forKey key: Key) async -> Value? {
    // 1. 먼저 Memory Cache 확인
    if let entry = try? await memoryStorage.retrieve(forKey: key) {
      let updatedEntry = entry.accessed()
      try? await memoryStorage.store(updatedEntry, forKey: key)
      return entry.value
    }
    
    // 2. Memory에 없으면, Disk Cache 확인
    if let entry = try? await diskStorage.retrieve(forKey: key) {
      let updatedEntry = entry.accessed()
      try? await memoryStorage.store(updatedEntry, forKey: key)
      try? await diskStorage.store(updatedEntry, forKey: key)
      return entry.value
    }
    
    // 3. 둘 다 없으면 nil 반환 -> Cache Miss~
    return nil
  }
  
  /// Memory & Disk Cache에서 key에 해당하는 캐시 항목 제거
  func remove(forKey key: Key) async {
    try? await memoryStorage.remove(forKey: key)// 1. Memory Cache에서 제거
    try? await diskStorage.remove(forKey: key)  // 2. Disk Cache에서 제거
  }
  
  
  /// Memory & Disk Cache 모두 초기화
  func removeAll() async {
    try? await memoryStorage.removeAll()      // 1. Memory Cache 초기화
    try? await diskStorage.removeAll()        // 2. Disk Cache 초기화
  }
  
  /// 일정 시간(interval)마다, Memory & Disk Cache에서 Expired 지난 항목들 제거
  ///
  /// - Parameters:
  ///   - interval: 시간 간격 (초 단위)
  ///
  /// - Note: `TwoTierCache`가 `deinit`될 때, 즉 `TwoTierCache` 인스턴스가 사라질 때, `expirationTimer`도 같이 취소
  func startExpirationTimer(interval: TimeInterval) async {
    expirationTimer?.cancel()
    
    expirationTimer = Task.detached { [weak self] in
      while !Task.isCancelled {
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000)) // interval초
        guard let self = self else { return }
        try? await self.memoryStorage.removeExpired()
        try? await self.diskStorage.removeExpired()
      }
    }
  }
}
