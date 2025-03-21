//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//
import Foundation
import SearchFeatureInterface
import ComposableArchitecture

extension SearchReducer {
  public init() {
    let searchReducer = Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.searchWord):
        if state.previousWord != state.searchWord {
          state.previousWord = state.searchWord
          return .send(.searchWordDidChange(state.searchWord))
        } else { return .none }
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(true))
          }
        }
      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none
      case let .searchWordDidChange(word):
        print(word)
        return .none
      case .binding:
        return .none
      }
    }
    
    self.init(reducer: searchReducer)
  }
}
