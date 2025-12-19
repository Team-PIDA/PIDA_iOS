//
//  WithdrawUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UserDomainInterface

public struct WithdrawUseCaseImpl: WithdrawUseCase {
  private let repository: UserRepository
  
  public init(repository: UserRepository) {
    self.repository = repository
  }
  public func execute() async throws {
    return try await repository.withdraw()
  }
}
