//
//  LogoutUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import UserDefault

public struct LogoutUseCaseImpl: LogoutUseCase {
  private let repository: AuthRepository
  
  public init(repository: AuthRepository) {
    self.repository = repository
  }
  
  public func execute() async throws {
    return try await repository.logout(token: UserDefault.accessToken ?? "")
  }
}
