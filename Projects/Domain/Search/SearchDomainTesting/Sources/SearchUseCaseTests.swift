//
//  SearchUseCaseTests.swift
//
//  Search
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import SearchDomain

final class SearchUseCaseTests: XCTestCase {
    
    func testExecute() async throws {
        let repository = MockSearchRepository()
        let useCase = SearchUseCaseImpl(repository: repository)

        let result = try await useCase.execute()
        XCTAssertEqual(result, "Mocked Data")
    }
}

final class MockSearchRepository: SearchRepository {
    func fetchData() async throws -> String {
        return "Mocked Data"
    }
}
