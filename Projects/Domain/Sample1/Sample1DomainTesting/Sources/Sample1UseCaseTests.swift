//
//  Sample1UseCaseTests.swift
//
//  Sample1
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import Sample1Domain

final class Sample1UseCaseTests: XCTestCase {
    
    func testExecute() async throws {
        let repository = MockSample1Repository()
        let useCase = Sample1UseCaseImpl(repository: repository)

        let result = try await useCase.execute()
        XCTAssertEqual(result, "Mocked Data")
    }
}

final class MockSample1Repository: Sample1Repository {
    func fetchData() async throws -> String {
        return "Mocked Data"
    }
}
