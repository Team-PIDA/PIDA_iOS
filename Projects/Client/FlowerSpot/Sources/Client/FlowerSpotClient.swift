//
//  FlowerSpotClient.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

@DependencyClient
public struct FlowerSpotClient: Sendable {
  public var fetchAllFlowerAddress: @Sendable () async throws -> FlowerSpotListEntity
  public var fetchAllFlowerPin: @Sendable(GetFlowerSpotQuery) async throws -> FlowerSpotListEntity
  public var getFlowerSpotDetail: @Sendable (Int) async throws -> FlowerSpotEntity
  public var saveAllFlowerSpotToCache: @Sendable (FlowerSpotListEntity) async throws -> Void
}

public extension DependencyValues {
  var flowerSpotClient: FlowerSpotClient {
    get { self[FlowerSpotClient.self] }
    set { self[FlowerSpotClient.self] = newValue }
  }
}
