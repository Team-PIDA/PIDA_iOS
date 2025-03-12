//
//  SampleReducer.swift
//
//  Sample
//
//  Created by yongin
//

import ComposableArchitecture

@Reducer
public struct SampleReducer {
    public struct State: Equatable {
        var count: Int = 0
    }

    public enum Action {
        case increment
        case decrement
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .none
            case .decrement:
                state.count -= 1
                return .none
            }
        }
    }
}
