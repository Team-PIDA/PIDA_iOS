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
    @Dependency(\.dismiss) var dismiss
    let searchReducer = Reduce<SearchState, Action> { state, action in
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
        
      // MARK: - Search
        
      case let .searchBarFocused(isFocused):
        state.isFocused = isFocused
        return .none
      case let .searchWordDidChange(word):
        print(word)
        return .none
      case let .initialSearchBar(text): // 서치바 초기화
        state.searchWord = text
        return .none
        
      // MARK: - Delegate
        
      case let .selectResult(result):
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(false))
            send(.delegate(.selectResult(result)))
          }
        }
      case .dismiss:
        return .run { send in
          await MainActor.run {
            send(.searchBarFocused(false))
            send(.delegate(.dismiss))
          }
        }
      case .binding, .delegate:
        return .none
      }
    }
    
    self.init(reducer: searchReducer)
  }
}
