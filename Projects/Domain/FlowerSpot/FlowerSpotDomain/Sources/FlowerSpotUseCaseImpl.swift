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

  public func execute() async throws -> Void { }
}
