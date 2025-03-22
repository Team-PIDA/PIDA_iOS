//
//  AuthUsecCase.swift
//
//  Auth
//
//  Created by JiYeon
//

import Foundation

public protocol AuthUseCase {
  func execute() async throws -> Void
}
