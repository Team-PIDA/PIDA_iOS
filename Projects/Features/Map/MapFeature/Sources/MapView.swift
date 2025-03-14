//
//  MapView.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import MapFeatureInterface
import ComposableArchitecture

public struct MapView: View {
  let store: StoreOf<MapReducer>
  
  public init(store: StoreOf<MapReducer>) {
    self.store = store
  }
  
  public var body: some View {
    MapViewRepresentable()
      .ignoresSafeArea()
  }
}
