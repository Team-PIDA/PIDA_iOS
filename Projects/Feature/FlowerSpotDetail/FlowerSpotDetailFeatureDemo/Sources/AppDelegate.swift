//
//  FlowerSpotDetailDemoApp.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

@main
struct FlowerSpotDetailDemoApp: App {
  let feature = FlowerSpotDetailFeature()

  var body: some Scene {
    WindowGroup {
      FlowerSpotDetailView(store: feature.store)
    }
  }
}

