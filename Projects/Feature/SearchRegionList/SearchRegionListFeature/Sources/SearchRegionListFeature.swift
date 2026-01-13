//
//  SearchRegionListFeature.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import SearchRegionListFeatureInterface
import ComposableArchitecture

extension SearchRegionListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      default:
        return .none
      }
    }
  }
}
