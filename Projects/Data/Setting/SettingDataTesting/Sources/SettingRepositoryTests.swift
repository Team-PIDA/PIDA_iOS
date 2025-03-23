//
//  SettingDataTests.swift
//
//  Setting
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import SettingDataInterface
@testable import SettingDomainInterface
@testable import Core

final class SettingRepositoryTests: XCTestCase {

  func testFetchData() async throws {
    let networker = MockNetworker()
    let repository = SettingRepositoryImpl(networker: networker)

    let result = try await repository.requestMockData()
    XCTAssertEqual(result, "Mocked API Data")
  }
}

final class SettingRepositoryImpl: SettingRepository {
  func requestMockData() async throws -> String {
    return "Mocked API Data"
  }
}
