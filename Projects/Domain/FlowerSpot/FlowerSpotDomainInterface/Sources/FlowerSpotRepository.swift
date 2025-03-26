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
    지역: String,
    남서쪽_위도: Double,
    남서쪽_경도: Double,
    북동쪽_위도: Double,
    북동쪽_경도: Double
  ) async throws -> FlowerSpotListEntity
  
}
