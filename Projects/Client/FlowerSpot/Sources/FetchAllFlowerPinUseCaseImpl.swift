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
    region: String?,
    swLat: Double?,
    swLng: Double?,
    neLat: Double?,
    neLng: Double?
  ) async throws -> [FlowerSpot] {
    let list = try await repository.getFlowerSpotList(
      region: region,
      swLat: swLat,
      swLng: swLng,
      neLat: neLat,
      neLng: neLng
    )
    return list.itemList
  }
}
