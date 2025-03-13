//
//  SampleDataTests.swift
//
//  Sample
//
//  Created by yongin
//

import XCTest
import Dependencies
@testable import SampleDataInterface
@testable import SampleDomainInterface
@testable import Core

final class SampleRepositoryTests: XCTestCase {

    func testFetchData() async throws {
        let networker = MockNetworker()
        let repository = SampleRepositoryImpl(networker: networker)

        let result = try await repository.requestMockData()
        XCTAssertEqual(result, "Mocked API Data")
    }
}

final class SampleRepositoryImpl: SampleRepository {
    func requestMockData() async throws -> String {
        return "Mocked API Data"
    }
}
