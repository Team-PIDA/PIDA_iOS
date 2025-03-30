//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture
import FlowerSpotDomainInterface
import SearchDomainInterface

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
    public var searchList: [SearchListCellEntity] = []
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case onAppear
    
    // MARK: - Search
    
    case searchBarFocused(Bool)
    case initialSearchBar(String)
    case updateSearchResults([SearchListCellEntity])
    
    // MARK: - Delegate
    
    case selectResult(FlowerSpot) // TODO: - 아이템 타입으로 변경
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
    case selectResult(FlowerSpot)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    reducer
  }
}
