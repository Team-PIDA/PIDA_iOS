//
//  CategoryFeature.swift
//  CategoryFeature
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CategoryFeatureInterface

extension CategoryListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .onAppear:
        return .none

      case let .tapCategory(id):
        state.selectedCategoryId = id
        let title = state.categoryList.first(where: { $0.id == id })?.title ?? ""
        return .send(.delegate(.tapCategory(title: title)))

      case .resetToAll:
        state.selectedCategoryId = 1
        return .none

      case let .storeFlowerSpots(flowerSpots):
        state.flowerSpots = flowerSpots
        state.isLoading = false
        state.isDataEmpty = flowerSpots.isEmpty
        return .none

      case let .flowerSpotTapped(flowerSpot):
        return .send(.delegate(.showFlowerSpotDetail(flowerSpot)))

      case .delegate:
        return .none
      }
    }
  }
}
