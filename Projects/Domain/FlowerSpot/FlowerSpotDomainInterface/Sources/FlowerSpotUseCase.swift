//
//  FlowerSpotUsecCase.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation

public protocol FetchAllFlowerPinUseCase {
  func execute(
    region: String,
    swLat: Double,
    swLng: Double,
    neLat: Double,
    neLng: Double
  ) async throws -> Void
}
