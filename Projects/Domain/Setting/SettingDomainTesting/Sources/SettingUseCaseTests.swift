//
//  SettingUseCaseTests.swift
//
//  Setting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import SettingDomain

final class SettingUseCaseTests: XCTestCase {
    
  func testExecute() async throws {
      let repository = MockSettingRepository()
      let useCase = SettingUseCaseImpl(repository: repository)

      let result = try await useCase.execute()
      XCTAssertEqual(result, "Mocked Data")
  }
}

final class MockSettingRepository: SettingRepository {
  func fetchData() async throws -> String {
      return "Mocked Data"
  }
}
