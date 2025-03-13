//
//  SampleView.swift
//
//  Sample
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SampleView: View {
    let store: StoreOf<SampleReducer>

    public init(store: StoreOf<SampleReducer>) {
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

