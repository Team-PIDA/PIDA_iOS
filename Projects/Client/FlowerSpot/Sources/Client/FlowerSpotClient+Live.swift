//
//  FlowerSpotClient+Live.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient
import CacheClient
import Shared

extension FlowerSpotClient: DependencyKey {
  public static var liveValue: FlowerSpotClient {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.cache) var cache
    
    return .init(
      fetchAllFlowerAddress: {
        guard await cache.get(.allFlowerSpots, as: [SearchAddressCacheModel].self) == .none else { return }
        // 캐시에 없을 때만 api 요청
        let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(getFlowerSpotQuery: .init())
        let result = try await apiClient.execute(endpoint).toCacheModel()
        try await cache.set(.allFlowerSpots, result)
      },
      fetchAllFlowerPin: { query in
        let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(getFlowerSpotQuery: query)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      getFlowerSpotDetail: { id in
        let endpoint = FlowerSpotEndpoint.getFlowerSpotDetail(id: id)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      saveAllFlowerSpotToCache: { flowerSpotEntity in
        try await cache.set(.allFlowerSpots, flowerSpotEntity)
      }
    )
  }
}
