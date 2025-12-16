//
//  UserDataTests.swift
//
//  User
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import UserDataInterface
@testable import UserDomainInterface
@testable import Core

final class UserRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = UserRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class UserRepositoryImpl: UserRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}
