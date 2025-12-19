//
//  UpdateBloomingUseCaseImpl.swift
//  BloomingDomain
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingDomainInterface

public struct UpdateBloomingUseCaseImpl: UpdateBloomingUseCase {
  private let repository: BloomingRepository
  
  public init(repository: BloomingRepository) {
    self.repository = repository
  }
  
  public func execute(id: Int, status: String) async throws {
    return try await repository.updateBlooming(id: id, status: status)
  }
}
