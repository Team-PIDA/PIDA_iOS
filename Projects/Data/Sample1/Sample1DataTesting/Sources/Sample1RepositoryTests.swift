//
//  Sample1DataTests.swift
//
//  Sample1
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import Sample1DataInterface
@testable import Sample1DomainInterface
@testable import Core

final class Sample1RepositoryTests: XCTestCase {

    func testFetchData() async throws {
        let networker = MockNetworker()
        let repository = Sample1RepositoryImpl(networker: networker)

        let result = try await repository.requestMockData()
        XCTAssertEqual(result, "Mocked API Data")
    }
}

final class Sample1RepositoryImpl: Sample1Repository {
    func requestMockData() async throws -> String {
        return "Mocked API Data"
    }
}
