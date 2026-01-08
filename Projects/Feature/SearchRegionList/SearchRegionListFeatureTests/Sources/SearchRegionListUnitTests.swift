//
//  SearchRegionListXCTest.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import XCTest
import ComposableArchitecture
@testable import SearchRegionListFeatureInterface

final class SearchRegionListUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: SearchRegionListFeature.State()) {
            SearchRegionListFeature()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: SearchRegionListFeature.State()) {
            SearchRegionListFeature()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
