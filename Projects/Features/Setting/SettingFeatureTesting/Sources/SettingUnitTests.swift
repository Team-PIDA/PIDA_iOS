//
//  SettingXCTest.swift
//
//  Setting
//
//  Created by JiYeon
//

import XCTest
import ComposableArchitecture
@testable import SettingInterface

final class SettingUnitTests: XCTestCase {
    
    func testIncrement() {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        }

        store.send(.increment) {
            $0.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        }

        store.send(.decrement) {
            $0.count = -1
        }
    }
}
