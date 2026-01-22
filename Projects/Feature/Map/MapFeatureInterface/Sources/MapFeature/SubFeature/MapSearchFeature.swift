//
//  MapSearchFeature.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 1/21/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Shared
import FlowerSpotClient

@Reducer
public struct MapSearchFeature {
  private let reducer: Reduce<State, Action>
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    /// 검색 결과 데이터
    public var searchResult: FlowerSpotEntity? = nil
    /// 검색 결과 텍스트
    public var searchText: String? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case showSearchResult(FlowerSpotEntity?)
    case setSearchBarText(String?)
    case resetSearchBar
    case presentToSearch
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showSearchResult(FlowerSpotEntity?)
    case presentToSearch(String?)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
