//
//  FlowerSpotDataTests.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import FlowerSpotDataInterface
@testable import FlowerSpotDomainInterface
@testable import Core

final class FlowerSpotRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = FlowerSpotRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class FlowerSpotRepositoryImpl: FlowerSpotRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}
