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
import Shared

@main
struct PIDAApp: App {
  
  init() {
    NMFAuthManager.shared().clientId = Constant.naver_map_client_id
    DependencyRegistry.registerDependencies()
  }
  
  var body: some Scene {
    WindowGroup {
      PIDAView()
    }
  }
}
