//
//  FlowerSpotDetailXCTest.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import XCTest
import ComposableArchitecture
@testable import FlowerSpotDetailInterface

final class FlowerSpotDetailUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: FlowerSpotDetailReducer.State()) {
            FlowerSpotDetailReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: FlowerSpotDetailReducer.State()) {
            FlowerSpotDetailReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
