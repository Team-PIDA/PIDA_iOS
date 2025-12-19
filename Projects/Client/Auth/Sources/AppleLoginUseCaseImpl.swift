//
//  AppleLoginUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface

public struct AppleLoginUseCaseImpl: AppleLoginUseCase {
  private let repository: AuthRepository
  
  public init(repository: AuthRepository) {
    self.repository = repository
  }
  
  public func execute(token: String) async throws -> SocialLoginEntity {
    return try await repository.requestAppleLogin(token: token)
  }
}
