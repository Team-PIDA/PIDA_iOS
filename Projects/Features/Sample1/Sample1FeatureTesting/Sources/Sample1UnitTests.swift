//
//  Sample1XCTest.swift
//
//  Sample1
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import Sample1Interface

final class Sample1UnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: Sample1Reducer.State()) {
            Sample1Reducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: Sample1Reducer.State()) {
            Sample1Reducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
