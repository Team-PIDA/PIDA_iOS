//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture

@ObservableState
public struct SearchState: Equatable {
  public var isFocused: Bool = false
  public var searchWord: String = ""
  public var previousWord: String = ""
  public init() {}
}

@Reducer
public struct SearchReducer {
  private let reducer: Reduce<SearchState, Action>
  
  public init(reducer: Reduce<SearchState, Action>) {
    self.reducer = reducer
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<SearchState>)
    
    case onAppear
    
    // MARK: - Search
    
    case searchBarFocused(Bool)
    case searchWordDidChange(String)
    case initialSearchBar(String)
    
    // MARK: - Delegate
    
    case selectResult(String) // TODO: - 아이템 타입으로 변경
    case dismiss
    case delegate(Delegate)
    
  }
  
  public enum Delegate: Equatable {
    case dismiss
    case selectResult(String)
  }

  public var body: some Reducer<SearchState, Action> {
    BindingReducer()
    reducer
  }
}
