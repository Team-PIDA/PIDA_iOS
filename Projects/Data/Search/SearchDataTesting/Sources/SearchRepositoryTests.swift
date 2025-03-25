//
//  SearchDataTests.swift
//
//  Search
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import SearchDataInterface
@testable import SearchDomainInterface
@testable import Core

final class SearchRepositoryTests: XCTestCase {

    func testFetchData() async throws {
        let networker = MockNetworker()
        let repository = SearchRepositoryImpl(networker: networker)

        let result = try await repository.requestMockData()
        XCTAssertEqual(result, "Mocked API Data")
    }
}

final class SearchRepositoryImpl: SearchRepository {
    func requestMockData() async throws -> String {
        return "Mocked API Data"
    }
}
