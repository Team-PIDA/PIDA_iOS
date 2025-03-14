//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct MapView: View {
    let store: StoreOf<MapReducer>

    public init(store: StoreOf<MapReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: \.count) { viewStore in
            VStack {
                Text("Count: \(viewStore.state)")
                    .font(.largeTitle)

                HStack {
                    Button("-") { viewStore.send(.decrement) }
                    Button("+") { viewStore.send(.increment) }
                }
                .padding()
            }
        }
    }
}

