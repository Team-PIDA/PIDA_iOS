//
//  CategoryFeature.swift
//  MapFeature
//
//  Created by Jiyeon on 3/4/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MapFeatureInterface

extension CategoryFeature {
  public init() {
    self.init(reducer: Reduce(Core()))
  }

  struct Core: Reducer {
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
      switch action {
      case .delegate: return .none
      }
    }
  }
}
