//
//  BloomingXCTest.swift
//
//  Blooming
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import BloomingInterface

final class BloomingUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: BloomingReducer.State()) {
            BloomingReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: BloomingReducer.State()) {
            BloomingReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
