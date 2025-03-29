//
//  AuthDemoApp.swift
//
//  Auth
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

@main
struct AuthDemoApp: App {
  let feature = AuthFeature()

  var body: some Scene {
    WindowGroup {
      AuthView(store: feature.store)
    }
  }
}

