//
//  MapDemoApp.swift
//
//  Map
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture
import MapFeatureInterface
import MapFeature

import NMapsMap

@main
struct MapDemoApp: App {
  let store = Store(initialState: MapReducer.State()) {
    MapReducer()
  }
  
  var body: some Scene {
    WindowGroup {
      MapView(store: store)
        
    }
  }
}
