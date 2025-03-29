//
//  BloomingUseCaseTests.swift
//
//  Blooming
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import BloomingDomain

final class BloomingUseCaseTests: XCTestCase {
    
  func testExecute() async throws {
      let repository = MockBloomingRepository()
      let useCase = BloomingUseCaseImpl(repository: repository)

      let result = try await useCase.execute()
      XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockBloomingRepository: BloomingRepository {
  func fetchData() async throws -> String {
      return "Mocked Data"
  }
}
