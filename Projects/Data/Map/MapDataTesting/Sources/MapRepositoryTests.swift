//
//  MapDataTests.swift
//
//  Map
//
//  Created by JiYeon
//

import XCTest
import Dependencies
@testable import MapDataInterface
@testable import MapDomainInterface
@testable import Core

final class MapRepositoryTests: XCTestCase {

    func testFetchData() async throws {
        let networker = MockNetworker()
        let repository = MapRepositoryImpl(networker: networker)

        let result = try await repository.requestMockData()
        XCTAssertEqual(result, "Mocked API Data")
    }
}

final class MapRepositoryImpl: MapRepository {
    func requestMockData() async throws -> String {
        return "Mocked API Data"
    }
}
