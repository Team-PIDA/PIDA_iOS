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
      case .binding, .delegate: return .none
      }
    }
  }
}
