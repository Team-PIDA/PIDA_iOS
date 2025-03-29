//
//  BloomingDemoApp.swift
//
//  Blooming
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct BloomingDemoApp: App {
  let feature = BloomingFeature()

  var body: some Scene {
    WindowGroup {
      BloomingView(store: feature.store)
    }
  }
}

