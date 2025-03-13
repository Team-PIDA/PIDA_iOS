//
//  SampleXCTest.swift
//
//  Sample
//
//  Created by yongin
//

import XCTest
import ComposableArchitecture
@testable import SampleInterface

final class SampleUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: SampleReducer.State()) {
            SampleReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: SampleReducer.State()) {
            SampleReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
