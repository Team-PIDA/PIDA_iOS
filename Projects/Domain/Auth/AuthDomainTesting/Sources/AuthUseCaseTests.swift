//
//  AuthUseCaseTests.swift
//
//  Auth
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import AuthDomain

final class AuthUseCaseTests: XCTestCase {
    
  func testExecute() async throws {
      let repository = MockAuthRepository()
      let useCase = AuthUseCaseImpl(repository: repository)

      let result = try await useCase.execute()
      XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockAuthRepository: AuthRepository {
  func fetchData() async throws -> String {
      return "Mocked Data"
  }
}
