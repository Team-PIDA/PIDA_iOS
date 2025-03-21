//
//  SearchReducer.swift
//
//  Search
//
//  Created by JiYeon
//

import SearchFeatureInterface
import ComposableArchitecture

extension SearchReducer {
  public init() {
    let searchReducer = Reduce<State, Action> { state, action in
      switch action {
        
      case .binding:
        return .none
      }
    }
    
    self.init(reducer: searchReducer)
  }
}
