//
//  Sample2XCTest.swift
//
//  Sample2
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import Sample2Interface

final class Sample2UnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: Sample2Reducer.State()) {
            Sample2Reducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: Sample2Reducer.State()) {
            Sample2Reducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
