//
//  Target+.swift
//  Config
//
//  Created by 조용인 on 3/8/25.
//

import Foundation
import ProjectDescription

public extension Target {
  static let organizationName = "com.pida.me.ios"
  
  enum SchemeType {
    case development
    case production
    
    var entitlementsPath: String {
      switch self {
      case .development: "Config/Debug.entitlements"
      case .production: "Config/Release.entitlements"
      }
    }
    
    var addedBundlePath: String {
      switch self {
      case .development: ".dev"
      case .production: ""
      }
    }
    
    var configPath: String {
      switch self {
      case .development: "Config/Debug.xcconfig"
      case .production: "Config/Release.xcconfig"
      }
    }
    
  }
  
  // MARK: - App Target 생성
  static func makeApp(
    name: String,
    env: SchemeType,
    infoPlist: [String: Plist.Value] = [:],
    script: [TargetScript] = [],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let config: Configuration = env == .development
    ? .debug(name: .debug, xcconfig: .relativeToRoot(env.configPath))
    : .release(name: .release, xcconfig: .relativeToRoot(env.configPath))
    return target(
      name: name,
      destinations: .iOS,
      product: .app,
      bundleId: organizationName + env.addedBundlePath,
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["./Sources/**"],
      resources: ["./Resources/**"],
      entitlements: .file(path: .relativeToRoot(env.entitlementsPath)),
      scripts: script,
      dependencies: dependencies,
      settings: .settings(
        configurations: [config]
      )
    )
  }
  
  // MARK: - Demo App Target 생성
  static func makeDemoTargets(
    name: String,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Target {
    return target(
      name: name + "Demo",
      destinations: .iOS,
      product: .app,
      bundleId: "\(organizationName).\(name)Demo",
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["./\(name)Demo/Sources/**"],
      resources: ["./\(name)Demo/Resources/**"],
      dependencies: dependencies
    )
  }
  
  // MARK: - Dynamic Framework로 세팅할 Interface Target 생성
  static func makeInterfaceTarget(
    name: String,
    layer: Layer,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let middle = layer.rawValue
    let sourcesPath = layer == .feature ? "./\(name)\(middle)Interface" : "."
    return target(
      name: "\(name)\(middle)Interface",
      destinations: .iOS,
      product: .framework,
      bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)Interface",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["\(sourcesPath)/Sources/**"],
      dependencies: dependencies
    )
  }
  
  // MARK: - Static Framework로 세팅할 Implementation Target 생성
  static func makeImplementTarget(
    name: String,
    layer: Layer,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let middle = layer.rawValue
    let sourcesPath = layer == .feature ? "./\(name)\(middle)" : "."
    return target(
      name: "\(name)\(middle)",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["\(sourcesPath)/Sources/**"],
      dependencies: dependencies
    )
  }
  
  // MARK: - Test Target 생성
  static func makeTestingTarget(
    name: String,
    layer: Layer,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let middle = layer.rawValue
    let sourcesPath = layer == .feature ? "./\(name)\(middle)Testing" : "."
    return target(
      name: "\(name)\(middle)Testing",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)Testing",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["\(sourcesPath)/Sources/**"],
      dependencies: dependencies
    )
  }
  
  // MARK: - Internal Module로 세팅할 Framwork Target 생성
  static func makeInternalFrameworkTarget(
    name: String,
    dependencies: [TargetDependency] = []
  ) -> Target {
    return target(
      name: name,
      destinations: .iOS,
      product: .framework,
      bundleId: "\(organizationName).\(name)", // com.yongin.pida.Network
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["./Sources/**"],
      dependencies: dependencies
    )
  }
}
