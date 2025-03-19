//
//  MapReducer.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import MapDomainInterface
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
    public var flowerPositions: [Int: FlowerPosition] = [:]
    public var selectedPathLines: [MapPoint] = []
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case fetchUserLocation
    case moveUserLocation
    case moveLocation(MapPoint)
    case fetchFlowers
    case storeFlowerData([FlowerPosition])
    case fetchPathLines(id: Int?)
    
    // delegate action
    case push
    case delegate(Delegate)
  }
  
  public enum Delegate {
    case push
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
