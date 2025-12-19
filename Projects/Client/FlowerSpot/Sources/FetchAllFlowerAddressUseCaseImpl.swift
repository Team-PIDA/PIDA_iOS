//
//  FetchAllFlowerAddressUseCaseImpl.swift
//  FlowerSpotDomain
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import FlowerSpotDomainInterface

public struct FetchAllFlowerAddressUseCaseImpl: FetchAllFlowerAddressUseCase {
  private let repository: FlowerSpotRepository

  public init(
    repository: FlowerSpotRepository
  ) {
    self.repository = repository
  }

  @discardableResult
  public func execute() async throws -> [FlowerSpot] {
    let list = try await repository.getFlowerSpotList(
      region: nil,
      swLat: nil,
      swLng: nil,
      neLat: nil,
      neLng: nil
    )
    try await repository.saveAllFlowerSpotToCache(flowerSpotList: list.itemList)
    return list.itemList
  }
}
