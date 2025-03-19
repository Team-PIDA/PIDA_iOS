//
//  Sample2Reducer.swift
//
//  Sample2
//
//  Created by JiYeon
//

import Sample2FeatureInterface
import ComposableArchitecture

extension Sample2Reducer {
  
  public init() {
    let sample2Reducer = Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    self.init(reducer: sample2Reducer)
  }
}
