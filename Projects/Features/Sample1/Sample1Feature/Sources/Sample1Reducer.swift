//
//  Sample1Reducer.swift
//
//  Sample1
//
//  Created by JiYeon
//

import Sample1FeatureInterface
import ComposableArchitecture

extension Sample1Reducer {
  
  public init() {
    let sample1Reducer = Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    self.init(reducer: sample1Reducer)
  }
}
