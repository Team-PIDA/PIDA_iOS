//
//  BloomingDataTests.swift
//
//  Blooming
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import BloomingDataInterface
@testable import BloomingDomainInterface
@testable import Core

final class BloomingRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = BloomingRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class BloomingRepositoryImpl: BloomingRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}
