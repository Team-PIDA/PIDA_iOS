//
//  SearchRepositoryImpl.swift
//
//  Search
//
//  Created by JiYeon
//

import Foundation
import SearchDataInterface
import SearchDomainInterface
import Core
import Cache

public struct SearchRepositoryImpl: SearchRepository {
  
  public init() {
    
  }
  
  public func getSearchListFromCache() async throws -> [AllFlowerSpotListModel] {
    // 1. 캐시에서 모든 꽃 정보 데이터 가져오기
    let cache = try await CacheActor.shared.allFlowerSpotListCache
    // 캐시에 데이터가 없으면 빈 배열 반환
    guard let allFlowerSpots = await cache.value(forKey: .init(.allFlowerSpotListModel, "all_flower_spots")) else {
      return []
    }
    return allFlowerSpots
  }
  
  /// 최근 검색 기록 저장
  public func saveRecentSearchToCache(spotItem: SearchListCellEntity) async throws -> Void {
    let cache = try await CacheActor.shared.recentSerachCache
    let cacheItem = RecentSearchItemModel(
      id: spotItem.id,
      address: spotItem.address,
      streetName: spotItem.streetName,
      data: Date()
    )
    var recentList = await cache.value(forKey: .init(.recentSearchList, "recent_search")) ?? []
    
    // 이미 존재하는 검색기록이면 제거 후 저장
    if let existIndex = recentList.firstIndex(where: { $0.id == cacheItem.id }) {
      recentList.remove(at: existIndex)
    }
    
    recentList.insert(cacheItem, at: 0)
    
    try await cache.insert(recentList, forKey: .init(.recentSearchList, "recent_search"))
  }
  
  public func fetchRecentSearchListFromCache() async throws -> [RecentSearchItemModel] {
    let cache = try await CacheActor.shared.recentSerachCache
    guard let item = await cache.value(forKey: .init(.recentSearchList, "recent_search")) else {
      return []
    }
    return item
  }
  
}
