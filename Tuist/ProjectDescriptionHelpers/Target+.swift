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
    
    // MARK: - App Target 생성
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
        return target(
            name: "\(name)\(middle)Interface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)Interface",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./**"],
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
        return target(
            name: "\(name)\(middle)",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./**"],
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
        return target(
            name: "\(name)\(middle)Testing",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)\(middle)Testing",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./**"],
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
            sources: ["./**"],
            dependencies: dependencies
        )
    }
}
