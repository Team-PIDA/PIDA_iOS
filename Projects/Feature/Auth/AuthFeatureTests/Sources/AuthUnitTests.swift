//
//  AuthXCTest.swift
//
//  Auth
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import AuthInterface

final class AuthUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: AuthReducer.State()) {
            AuthReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: AuthReducer.State()) {
            AuthReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
