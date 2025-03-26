//
//  FlowerSpotUseCaseImpl.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import FlowerSpotDomainInterface

public struct FetchAllFlowerPinUseCaseImpl: FetchAllFlowerPinUseCase {
  private let repository: FlowerSpotRepository

  public init(
    repository: FlowerSpotRepository
  ) {
    self.repository = repository
  }

  public func execute(
    region: String,
    swLat: Double,
    swLng: Double,
    neLat: Double,
    neLng: Double
  ) async throws -> Void {
    let list = try await repository.getFlowerSpotList(
      region: region,
      swLat: swLat,
      swLng: swLng,
      neLat: neLat,
      neLng: neLng
    )
    print("호출 목록: ", list)
  }
}
