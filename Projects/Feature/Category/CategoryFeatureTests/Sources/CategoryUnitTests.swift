//
//  CategoryXCTest.swift
//
//  Category
//
//  Created by Jiyeon
//

import XCTest
import ComposableArchitecture
@testable import CategoryListFeatureInterface

final class CategoryUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: CategoryListFeature.State()) {
            CategoryListFeature()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: CategoryListFeature.State()) {
            CategoryListFeature()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
