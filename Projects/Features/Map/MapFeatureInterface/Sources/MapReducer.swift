//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MapReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: Equatable {
    public var position: MapPoint? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case fetchUserLocation
    case moveUserLocation
    case moveLocation(MapPoint)
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}

// TODO: - Domain으로 이동
public struct MapPoint: Equatable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
