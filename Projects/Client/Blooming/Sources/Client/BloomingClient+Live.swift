//
//  BloomingClient+Live.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient
import Shared

extension BloomingClient: DependencyKey {
  public static var liveValue: BloomingClient {
    @Dependency(\.apiClient) var apiClient
    
    return .init(
      getBloomingState: { id in
        let endpoint = BloomingEndPoint.getBloomingState(id: id)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      updateBloomingState: { id, status in
        let body = UpdateBloomingBody(flowerSpotId: id, status: status)
        let endpoint = BloomingEndPoint.updateBlooming(body: body)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      verifyBloomingToday: { id in
        let endpoint = BloomingEndPoint.verifyBloomingToday(id: id)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      }
    )
  }
  
}
