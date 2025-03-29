//
//  AuthDataTests.swift
//
//  Auth
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import AuthDataInterface
@testable import AuthDomainInterface
@testable import Core

final class AuthRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = AuthRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class AuthRepositoryImpl: AuthRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}
