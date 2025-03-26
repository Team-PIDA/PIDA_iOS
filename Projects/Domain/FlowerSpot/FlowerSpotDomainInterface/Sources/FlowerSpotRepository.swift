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
    region: String,
    swLat: Double,
    swLng: Double,
    neLat: Double,
    neLng: Double
  ) async throws -> FlowerSpotListEntity
  
}
