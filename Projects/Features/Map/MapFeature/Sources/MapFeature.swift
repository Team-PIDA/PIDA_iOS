//
//  Map.swift
//
//  Map
//
//  Created by JiYeon
//

import MapFeatureInterface
import ComposableArchitecture

public struct MapFeature: MapInterface {
    public let store: StoreOf<MapReducer>

    public init() {
        self.store = Store(initialState: MapReducer.State()) {
            MapReducer()
        }
    }
}
