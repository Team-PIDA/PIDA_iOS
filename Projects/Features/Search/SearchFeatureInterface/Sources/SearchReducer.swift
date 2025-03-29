//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import ComposableArchitecture
import FlowerSpotDomainInterface

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
    public var searchList: [FlowerSpot] = [.init(id: 1, address: "서울특별시 강서구 곰달래로 51", recentlyVisitedCount: 0, bloomingStatus: .none, streetName: "곰달래로", path: [.init(latitude: 37.53011, longitude: 126.83845), .init(latitude: 37.53238, longitude: 126.86331)], pinPoint: .init(latitude: 37.53086, longitude: 126.8514), region: "SEOUL")]
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case onAppear
    
    // MARK: - Search
    
    case searchBarFocused(Bool)
    case initialSearchBar(String)
    
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
