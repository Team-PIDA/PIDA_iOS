//
//  BloomingUseCaseImpl.swift
//
//  Blooming
//
//  Created by JiYeon
//

import Foundation
import BloomingDomainInterface

public struct BloomingUseCaseImpl: BloomingUseCase {
  private let repository: BloomingRepository

  public init(
    repository: BloomingRepository
  ) {
    self.repository = repository
  }

  public func execute() async throws -> Void { }
}
