//
//  AuthUseCaseImpl.swift
//
//  Auth
//
//  Created by JiYeon
//

import Foundation
import AuthDomainInterface

public struct AuthUseCaseImpl: AuthUseCase {
  private let repository: AuthRepository

  public init(
    repository: AuthRepository
  ) {
    self.repository = repository
  }

  public func execute() async throws -> Void { }
}
