//
//  FlowerSpotRepositoryImpl.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import FlowerSpotDataInterface
import FlowerSpotDomainInterface
import Networker

public struct FlowerSpotRepositoryImpl: FlowerSpotRepository {
  private let networker: NetworkProtocol

  public init(
    networker: NetworkProtocol
  ) {
    self.networker = networker
  }

  public func getFlowerSpotList(
    region: String,
    swLat: Double,
    swLng: Double,
    neLat: Double,
    neLng: Double
  ) async throws -> FlowerSpotListEntity {
    let endpoint = FlowerSpotEndpoint.getFlowerSpotWithArea(
      getFlowerSpotParameter: .init(
        region: region,
        swLat: swLat,
        swLng: swLng,
        neLat: neLat,
        neLng: neLng
      )
    )
    return try await networker.execute(with: endpoint, timeout: 60).toEntity()
  }
}
