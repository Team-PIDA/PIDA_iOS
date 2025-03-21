//
//  CacheActor.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 접근을 위한 전역 액터
@globalActor
public actor CacheActor {
  public static let shared = CacheActor()
  
  // 다양한 타입의 캐시를 저장할 dictionary
  private var caches: [String: Any] = [:]
  
  // 특정 타입의 캐시를 가져오거나 생성
  public func cache<Namespace: CacheNamespace, Value: Codable>(
    namespace: Namespace.Type,
    valueType: Value.Type,
    ttl: TTLScale = .medium,
    eviction: EvictionPolicy = .lru(100),
    cacheName: String = String(describing: Value.self)
  ) async throws -> TwoTierCache<Namespace, Value> {
    let cacheKey = "\(cacheName)_\(String(describing: Value.self))_\(String(describing: Namespace.self))"
    
    if let existingCache = caches[cacheKey] as? TwoTierCache<Namespace, Value> {
      return existingCache
    }
    
    let newCache = try await TwoTierCache<Namespace, Value>(
      defaultTTL: ttl,
      eviction: eviction,
      cacheName: cacheName
    )
    
    caches[cacheKey] = newCache
    return newCache
  }
}

/// 기본 캐시 타입들에 대한 편리한 접근 제공
extension CacheActor {
  // 검색 결과 캐시
  public var searchResultCache: TwoTierCache<DefaultNamespace, SearchResultCacheModel> {
    get async throws {
      return try await cache(
        namespace: DefaultNamespace.self,
        valueType: SearchResultCacheModel.self,
        ttl: .high,
        eviction: .lru(50),
        cacheName: "searchResults"
      )
    }
  }
  
  // 검색 기록 캐시
  public var searchHistoryCache: TwoTierCache<DefaultNamespace, SearchHistoryCacheModel> {
    get async throws {
      return try await cache(
        namespace: DefaultNamespace.self,
        valueType: SearchHistoryCacheModel.self,
        ttl: .high,
        eviction: .fifo(20),
        cacheName: "searchHistory"
      )
    }
  }
}
