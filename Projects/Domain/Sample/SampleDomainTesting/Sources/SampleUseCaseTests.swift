//
//  SampleUseCaseTests.swift
//
//  Sample
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import SampleDomain

final class SampleUseCaseTests: XCTestCase {
    
    func testExecute() async throws {
        let repository = MockSampleRepository()
        let useCase = SampleUseCaseImpl(repository: repository)

        let result = try await useCase.execute()
        XCTAssertEqual(result, "Mocked Data")
    }
}

final class MockSampleRepository: SampleRepository {
    func fetchData() async throws -> String {
        return "Mocked Data"
    }
}
