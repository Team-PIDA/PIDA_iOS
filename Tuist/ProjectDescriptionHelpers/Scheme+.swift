//
//  Scheme.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/13/25.
//

import Foundation
import ProjectDescription

public let organization: String = "com.pida.me"

public enum Scheme {
  case dev
  case release
  
  public var BUNDLE_ID: String {
    switch self {
    case .dev: "com.pida.me.ios-dev"
    case .release: "com.pida.me.ios"
    }
  }
  
  public var CONFIGURATION: String {
    switch self {
    case .dev: "Debug"
    case .release: "Release"
    }
  }
  
  public var ENTITLEMENTS_PATH: String {
    switch self {
    case .dev: "Config/Debug.entitlements"
    case .release: "Config/Release.entitlements"
    }
  }
  
  public var GLOB_EXCLUDING: [Path] {
    switch self {
    case .dev: ["Resources/Release/**"]
    case .release: ["Resources/Dev/**"]
    }
  }
  
  public var SETTING: ProjectDescription.Settings {
    switch self {
    case .dev: Settings.dev
    case .release: Settings.release
    }
  }
  
  public var SCRIPT: [TargetScript] {
    switch self {
    case .dev: []
    case .release:[]
    }
  }
  
  public var APP_ICON_NAME: String {
    switch self {
    case .dev: "AppIcon_dev"
    case .release: "AppIcon"
    }
  }

  public var APP_DISPLAY_NAME: String {
    switch self {
    case .dev: "피다 Dev"
    case .release: "피다"
    }
  }

  public var INFO_PLIST: [String: Plist.Value] {
    return [
      "CFBundleDevelopmentRegion": "ko_KR",
      "CFBundleShortVersionString": "1.2.2",
      "CFBundleVersion": "1",
      "CFBundleDisplayName": .string(APP_DISPLAY_NAME),
      "CFBundleIconName": .string(APP_ICON_NAME),
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": []
      ],
      "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
      ],
      "NSLocationWhenInUseUsageDescription": "지도에서 내 위치를 확인하여 길찾기, 네비게이션 기능을 이용하기 위해 권한이 필요합니다.(필수권한)",
      "NMCLIENTID": "$(NM_CLIENT_ID)",
      "BASE_URL": "$(BASE_URL)",
      "MIXPANEL_TOKEN": "$(MIXPANEL_TOKEN)",
      "ITSAppUsesNonExemptEncryption": false,
      // Firebase
      "FirebaseAppDelegateProxyEnabled": false,
      // Push Notification Background Mode
      "UIBackgroundModes": ["remote-notification"],
    ]
  }
}
