//
//  AppVersionService.swift
//  Utility
//
//  Created by Jiyeon on 4/1/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UIKit

public final actor AppVersionManager {
  public static let shared = AppVersionManager()
  private init() {}
  
  public var currentVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
  }
  
  private func fetchAppStoreVersion(bundleId: String) async -> String? {
    guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)") else { return nil }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
         let results = json["results"] as? [[String: Any]],
         let appStoreVersion = results.first?["version"] as? String {
        return appStoreVersion
      }
    } catch {
      print("Error fetching App Store version: \(error)")
    }
    return nil
  }
  
  public func getVersionInfo() async -> (current: String, appStore: String, updateNeeded: Bool) {
    guard let bundleId = Bundle.main.bundleIdentifier,
          let storeVersion = await fetchAppStoreVersion(bundleId: bundleId)
    else {
      return (current: currentVersion, appStore: "0.0", updateNeeded: false)
    }
    // 단순 문자열 비교. 실제 버전 비교 로직은 필요에 따라 개선
    let updateNeeded = storeVersion > currentVersion
    return (current: currentVersion, appStore: storeVersion, updateNeeded: updateNeeded)
  }
}
