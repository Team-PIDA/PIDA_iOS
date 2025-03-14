//
//  Sample.swift
//
//  Sample
//
//  Created by JiYeon
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
