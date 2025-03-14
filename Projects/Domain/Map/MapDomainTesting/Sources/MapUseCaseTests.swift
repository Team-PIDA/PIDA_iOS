//
//  MapUseCaseTests.swift
//
//  Map
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import MapDomain

final class MapUseCaseTests: XCTestCase {
    
    func testExecute() async throws {
        let repository = MockMapRepository()
        let useCase = MapUseCaseImpl(repository: repository)

        let result = try await useCase.execute()
        XCTAssertEqual(result, "Mocked Data")
    }
}

final class MockMapRepository: MapRepository {
    func fetchData() async throws -> String {
        return "Mocked Data"
    }
}
