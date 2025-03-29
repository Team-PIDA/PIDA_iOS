//
//  SignUpUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface

public struct SignUpUseCaseImpl: SignUpUseCase {
  private let repository: AuthRepository
  
  public init(repository: AuthRepository) {
    self.repository = repository
  }
  
  public func execute(email: String, nickname: String) async throws -> Void {
    let result = try await repository.signUp(email: email, nickname: nickname)
    print(result.message)
  }
}
