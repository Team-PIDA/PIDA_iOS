//
//  PIDAApp.swift
//  PIDA
//
//  Created by Jiyeon on 3/13/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import MapFeature
import NMapsMap

@main
struct PIDAApp: App {
  
  init() {
    NMFAuthManager.shared().clientId = Bundle.main.infoDictionary?["NMCLIENTID"] as? String
    DependencyRegistry.registerDependencies()
  }
  
  var body: some Scene {
    WindowGroup {
      PIDAView()
    }
  }
}
