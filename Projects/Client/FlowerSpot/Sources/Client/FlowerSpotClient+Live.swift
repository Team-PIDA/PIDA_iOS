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
      fetchAllFlowerPin: { query in
        let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(getFlowerSpotQuery: query)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      getFlowerSpotDetail: { id in
        let endpoint = FlowerSpotEndpoint.getFlowerSpotDetail(id: id)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      }
    )
  }
}
