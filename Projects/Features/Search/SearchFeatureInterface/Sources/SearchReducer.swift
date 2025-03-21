//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct SearchReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var isFocused: Bool = false
    public var searchWord: String = ""
    public var previousWord: String = ""
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
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

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
