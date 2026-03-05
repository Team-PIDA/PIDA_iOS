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

extension CategoryFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case let .tapCategory(id):
        state.selectedCategoryId = id
        if id == 1 {
          return .send(.delegate(.resetCategory))
        }
        let title = state.categoryList.first(where: { $0.id == id })?.title ?? ""
        return .send(.delegate(.tapCategory(title: title)))

      case .resetToAll:
        state.selectedCategoryId = 1
        return .none

      case .delegate: return .none
      }
    }
  }
}
