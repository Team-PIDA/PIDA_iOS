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
        let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(getFlowerSpotQuery: .init())
        let result = try await apiClient.execute(endpoint).toEntity()
        //TODO: Cache에 저장
        return result.itemList
      },
      fetchAllFlowerPin: { region, swLat, swLng, neLat, neLng in
        let query = GetFlowerSpotQuery(
          region: region,
          swLat: swLat,
          swLng: swLng,
          neLat: neLat,
          neLng: neLng
        )
        let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(getFlowerSpotQuery: query)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result.itemList
      },
      getFlowerSpotDetail: { id in
        let endpoint = FlowerSpotEndpoint.getFlowerSpotDetail(id: id)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      saveAllFlowerSpotToCache: { flowerSpotEntity in
        try await cache.set(.allFlowerSpots, flwowerSpotEntity)
      }
    )
  }
}
