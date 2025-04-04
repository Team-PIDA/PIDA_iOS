//
//  VerifyBloomingTodayUseCaseImpl.swift
//  BloomingDomain
//
//  Created by 조용인 on 4/4/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingDomainInterface

public struct VerifyBloomingTodayUseCaseImpl: VerifyBloomingTodayUseCase {
  private let repository: BloomingRepository
  
  public init(repository: BloomingRepository) {
    self.repository = repository
  }
  
  public func execute(id: Int) async throws -> VerifyBloomingStateEntity {
    return try await repository.verifyBloomingToday(id: id)
  }
}
