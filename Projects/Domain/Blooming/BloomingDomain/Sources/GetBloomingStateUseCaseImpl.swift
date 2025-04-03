//
//  GetBloomingStateUseCaseImpl.swift
//  BloomingDomain
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingDomainInterface

public struct GetBloomingStateUseCaseImpl: GetBloomingStateUseCase {
  private let repository: BloomingRepository
  
  public init(repository: BloomingRepository) {
    self.repository = repository
  }
  
  public func execute(id: Int) async throws -> BloomStatusEntity {
    return try await repository.getBloomingState(id: id)
  }
}
