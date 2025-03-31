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
    public var recentList: [SearchListCellEntity] = []
    public var showRecentList: Bool = true
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case onAppear
    
    // MARK: - Search
    
    case searchBarFocused(Bool)
    case configureSearchList
    case searchItem(String)
    
    case updateSearchResults([SearchListCellEntity])
    case fetchSearchResult(FlowerSpot)
    case fetchRecentResult
    
    case storeRecentResult([SearchListCellEntity])
    case initialSearchBar(String)
   
    
    // MARK: - Delegate
    
    case selectResult(SearchListCellEntity)
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
