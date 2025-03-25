//
//  FlowerSpotUseCaseTests.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import FlowerSpotDomain

final class FlowerSpotUseCaseTests: XCTestCase {
    
  func testExecute() async throws {
      let repository = MockFlowerSpotRepository()
      let useCase = FlowerSpotUseCaseImpl(repository: repository)

      let result = try await useCase.execute()
      XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockFlowerSpotRepository: FlowerSpotRepository {
  func fetchData() async throws -> String {
      return "Mocked Data"
  }
}
