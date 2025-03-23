//
//  SettingDemoApp.swift
//
//  Setting
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct SettingDemoApp: App {
  let feature = SettingFeature()

  var body: some Scene {
    WindowGroup {
      SettingView(store: feature.store)
    }
  }
}

