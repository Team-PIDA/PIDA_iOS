//
//  SearchFeature.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture
import SearchClient
import FlowerSpotClient
import Shared

@Reducer
public struct SearchFeature {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }

  @ObservableState
  public struct State: Equatable {
    public var isFocused: Bool = false
    public var searchWord: String = ""
    public var searchList: [PlaceSearchEntity] = []
    public var recentList: [PlaceSearchEntity] = []
    public var showRecentList: Bool = true
    public init(initText: String?) {
      self.searchWord = initText ?? ""
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case onAppear
    
    // MARK: - Search
    
    case searchBarFocused(Bool)
    case configureSearchList
    case searchItem(String)
    
    case updateSearchResults([PlaceSearchEntity])
    case fetchSearchResult(FlowerSpotEntity)
    case fetchRecentResult
    
    case updateRecentSesarch(PlaceSearchEntity)
    case storeRecentResult([PlaceSearchEntity])
    case initialSearchBar(String?)
   
    
    // MARK: - Delegate
    
    case selectResult(PlaceSearchEntity)
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
    case selectResult(FlowerSpotEntity)
    case selectRegionResult(RegionInfoEntity)
  }
  
  public enum CancelID {
    case search
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    reducer
  }
}

