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
}
