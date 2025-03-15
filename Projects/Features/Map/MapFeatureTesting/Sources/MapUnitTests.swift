//
//  MapXCTest.swift
//
//  Map
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import MapInterface

final class MapUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: MapReducer.State()) {
            MapReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: MapReducer.State()) {
            MapReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
