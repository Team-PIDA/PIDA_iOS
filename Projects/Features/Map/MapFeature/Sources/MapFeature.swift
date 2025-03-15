//
//  Map.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import MapFeatureInterface
import ComposableArchitecture

public struct MapFeature: MapInterface {
  public var reducer: StoreOf<MapReducer>
  
  public init(reducer: StoreOf<MapReducer>) {
    self.reducer = reducer
  }
  
  public func startView() -> AnyView {
    return AnyView(MapView(store: reducer))
  }
}
