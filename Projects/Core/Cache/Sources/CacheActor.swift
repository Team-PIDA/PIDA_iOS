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
  
  /// `CacheKey`에 대한 `TwoTierCache`(`MemoryCache` & `DiskCache`)를 관리하는 `Root Cache`입니다.
  private var rootCache: [String: Any] = [:]
  
  /// `TwoTierCache`를 생성하고, `rootCache`에 저장합니다.
  /// - Parameters:
  ///  - rootCacheKey(required): `rootCache`의 `Key`로 사용 할 `Namespace`입니다. 사용시에는 `.rawValue`로 `String`으로 변환하여 사용합니다.
  ///  - ttl(optional): 캐시의 유지 시간입니다.(default: medium = 1시간)
  ///  - eviction(optional): 캐시의 삭제 정책입니다.(default: lru = Least Recently Used)
  private func cache<Namespace: CacheNamespace, Value: Codable & Sendable>(
    rootCacheKey: Namespace,
    ttl: TTLScale = .medium,
    eviction: EvictionPolicy = .lru(100)
  ) async throws -> TwoTierCache<Namespace, Value> {
    let cacheName = rootCacheKey.rawValue
    if let existingCache = rootCache[cacheName] as? TwoTierCache<Namespace, Value> {
      return existingCache
    }
    
    let newCache = try await TwoTierCache<Namespace, Value>(
      defaultTTL: ttl,
      eviction: eviction,
      cacheName: cacheName
    )
    
    rootCache[cacheName] = newCache
    return newCache
  }
}

extension CacheActor {
  
  /// 외부 모듈에서 `searchResults` 캐시에 접근할 수 있도록 제공하는 `public` extension
  /// - Note: `TwoTierCache`를 사용하여 캐시를 저장하고 관리합니다.
  public var searchResultCache: TwoTierCache<Search, SearchResultCacheModel> {
    get async throws {
      return try await cache(
        rootCacheKey: .searchResult,
        ttl: .high,
        eviction: .lru(50)
      )
    }
  }
  
  /// 외부 모듈에서 `searchHistory` 캐시에 접근할 수 있도록 제공하는 `public` extension
  /// - Note: `TwoTierCache`를 사용하여 캐시를 저장하고 관리합니다.
  public var searchHistoryCache: TwoTierCache<Search, SearchHistoryCacheModel> {
    get async throws {
      return try await cache(
        rootCacheKey: .searchHistory,
        ttl: .high,
        eviction: .fifo(20)
      )
    }
  }
}
