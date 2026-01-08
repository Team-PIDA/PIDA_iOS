//
//  SearchRegionListFeatureDemoApp.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct SearchRegionListDemoApp: App {
  let feature = SearchRegionListFeature()

  var body: some Scene {
    WindowGroup {
      SearchRegionListView(store: feature.store)
    }
  }
}

