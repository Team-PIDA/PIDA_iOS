//
//  SearchXCTest.swift
//
//  Search
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import SearchInterface

final class SearchUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
