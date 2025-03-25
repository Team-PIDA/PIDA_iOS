//
//  FlowerSpotRepository.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation

public protocol FlowerSpotRepository {
  func fetchData() async throws -> Void
}
