//
//  Sample.swift
//
//  Sample
//
//  Created by yongin
//

import ComposableArchitecture

public struct SampleFeature: SampleInterface {
    public let store: StoreOf<SampleReducer>

    public init() {
        self.store = Store(initialState: SampleReducer.State()) {
            SampleReducer()
        }
    }
}
