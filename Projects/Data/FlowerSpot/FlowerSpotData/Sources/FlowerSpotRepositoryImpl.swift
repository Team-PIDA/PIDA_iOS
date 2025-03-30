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
import Cache

public struct FlowerSpotRepositoryImpl: FlowerSpotRepository {
  private let networker: NetworkProtocol
  
  public init(
    networker: NetworkProtocol
  ) {
    self.networker = networker
  }
  
  public func getFlowerSpotList(
    region: String?,
    swLat: Double?,
    swLng: Double?,
    neLat: Double?,
    neLng: Double?
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
  
  public func getFlowerSpotDetail(id: Int) async throws -> FlowerSpot {
    let endpoint = FlowerSpotEndpoint.getFlowerSpotDetail(id: id)
    return try await networker.execute(with: endpoint, timeout: 60).toEntity()
  }
  
  public func saveAllFlowerSpotToCache(flowerSpotList: [FlowerSpot]) async throws -> Void {
    let cache = try await CacheActor.shared.allFlowerSpotListCache
    let allSpots = flowerSpotList.map {
      AllFlowerSpotListModel(
        id: $0.id,
        address: $0.address,
        streetName: $0.streetName
      )
    }
    
    try await cache.insert(allSpots, forKey: .init(.allFlowerSpotListModel, "all_flower_spots"))
  }
  
}
