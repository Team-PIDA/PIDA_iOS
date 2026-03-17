//
//  CategoryFeatureDemoApp.swift
//
//  Category
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

@main
struct CategoryDemoApp: App {
  let feature = CategoryFeature()

  var body: some Scene {
    WindowGroup {
      CategoryView(store: feature.store)
    }
  }
}

