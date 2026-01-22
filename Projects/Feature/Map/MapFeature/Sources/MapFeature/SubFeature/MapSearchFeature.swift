//
//  MapSearchFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 1/21/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MapFeatureInterface
import Shared

extension MapSearchFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }
  
  struct Core: Reducer {
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
        
      case let .showSearchResult(result):
        state.searchResult = result
        return .send(.delegate(.showSearchResult(result)))
        
      case let .setSearchBarText(text):
        state.searchText = text
        return .none
        
      case .resetSearchBar:
        return .concatenate(
          .send(.showSearchResult(nil)),
          .send(.setSearchBarText(nil))
        )
        
      case .presentToSearch:
        return .send(.delegate(.presentToSearch(state.searchText)))
        
        
      case .binding, .delegate: return .none
      }
    }
  }
}
