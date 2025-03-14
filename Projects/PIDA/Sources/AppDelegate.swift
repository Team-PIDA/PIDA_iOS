//
//  AppDelegate.swift
//  PIDA
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import NMapsMap

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    NMFAuthManager.shared().clientId = Bundle.main.infoDictionary?["NMClientID"] as? String
    return true
  }
}
