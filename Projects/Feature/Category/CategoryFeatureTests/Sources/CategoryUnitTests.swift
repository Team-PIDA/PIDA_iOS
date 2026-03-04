//
//  CategoryXCTest.swift
//
//  Category
//
//  Created by Jiyeon
//

import XCTest
import ComposableArchitecture
@testable import CategoryFeatureInterface

final class CategoryUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: CategoryFeature.State()) {
            CategoryFeature()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: CategoryFeature.State()) {
            CategoryFeature()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
