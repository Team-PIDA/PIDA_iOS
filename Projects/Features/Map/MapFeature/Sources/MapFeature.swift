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
  
  public init() { }
  
  public func startView(store: StoreOf<MapReducer>) -> AnyView {
    return AnyView(MapView(store: store))
  }
}
