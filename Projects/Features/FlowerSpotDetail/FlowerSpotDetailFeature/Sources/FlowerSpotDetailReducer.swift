//
//  FlowerSpotDetailReducer.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import FlowerSpotDetailFeatureInterface
import ComposableArchitecture

extension FlowerSpotDetailReducer {
  public static let FlowerSpotDetailReducer = Reduce<State, Action> { state, action in
    switch action {
    default:
      return .none
    }
  }
}
