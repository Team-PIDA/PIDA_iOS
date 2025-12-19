//
//  GetFlowerSpotDetailUseCaseImpl.swift
//  FlowerSpotDomain
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import FlowerSpotDomainInterface

public struct GetFlowerSpotDetailUseCaseImpl: GetFlowerSpotDetailUseCase {
  private let repository: FlowerSpotRepository

  public init(
    repository: FlowerSpotRepository
  ) {
    self.repository = repository
  }

  public func execute(id: Int) async throws -> FlowerSpot {
    return try await repository.getFlowerSpotDetail(id: id)
  }
}
