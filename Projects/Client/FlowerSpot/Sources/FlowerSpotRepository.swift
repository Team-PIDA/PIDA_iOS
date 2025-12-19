//
//  FlowerSpotRepository.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation

public protocol FlowerSpotRepository {
  func getFlowerSpotList(
    region: String?,
    swLat: Double?,
    swLng: Double?,
    neLat: Double?,
    neLng: Double?
  ) async throws -> FlowerSpotListEntity
  
  func getFlowerSpotDetail(id: Int) async throws -> FlowerSpot
  
  func saveAllFlowerSpotToCache(flowerSpotList: [FlowerSpot]) async throws -> Void
}
