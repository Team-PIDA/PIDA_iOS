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
import CategoryClient

extension CategoryListFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case let .tapCategory(id):
        state.selectedFilterId = id
        return .none

      case let .storeSpots(flowerSpots):
        state.flowerSpots = flowerSpots
        state.isLoading = false
        state.isDataEmpty = flowerSpots.isEmpty
        state.headerTitle = state.categoryItem.title(count: flowerSpots.count)
        return .none

      case let .spotTapped(id):
        guard let flowerSpot = state.flowerSpots.first(where: { $0.id == id }) else { return .none }
        return .send(.delegate(.showFlowerSpotDetail(flowerSpot)))

      case .delegate:
        return .none
      }
    }
  }
}

extension CategoryEntity {
  func title(count: Int) -> String {
    switch self.type {
    case .festival: return "2026 벚꽃 축제 \(count)곳"
    case .trail: return "주변에 걷기 좋은 산책로 \(count)곳이 있어요"
    case .cafe: return "주변에 벚꽃 뷰 카페 \(count)곳을 찾았어요"
    default: return ""
    }
  }
}
