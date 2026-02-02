//
//  SearchClient+Live.swift
//  SearchClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import CacheClient
import Shared
import APIClient

extension SearchClient: DependencyKey {
  public static var liveValue: SearchClient {
    @Dependency(\.cache) var cache
    @Dependency(\.apiClient) var apiClient
    
    return .init(
      fetchRecentSearch: {
        guard let items = await cache.get(.recentSearches, as: [PlaceSearchEntity].self)
        else { return [] }
        return items
      },
      saveRecentSearchItem: { entity in
        guard let allList = await cache.get(.recentSearches, as: [PlaceSearchEntity].self)
        else {
          // 캐시에 최근 검색어가 하나도 없으면 새로 생성
          try await cache.set(.recentSearches, [entity])
          return
        }
        var updated = allList
        if let existingIndex = updated.firstIndex(where: { $0.uuid == entity.uuid }) {
          updated.remove(at: existingIndex)
        }
        
        if updated.count > 20 { updated.removeLast() }
          
        updated.insert(entity, at: 0)
        try await cache.set(.recentSearches, updated)
      },
      fetchKeywordSearch: { keyword in
        let query = PlaceSearchQuery(query: keyword)
        let endpoint = SearchEndPoint.searchPlaces(query: query)
        return try await apiClient.execute(endpoint).toEntity()
      }
    )
  }
}
