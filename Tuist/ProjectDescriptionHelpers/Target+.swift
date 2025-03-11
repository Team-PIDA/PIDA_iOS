//
//  Target+.swift
//  Config
//
//  Created by 조용인 on 3/8/25.
//

import Foundation
import ProjectDescription

public extension Target {
    static let organizationName = "com.yongin.pida"
    
    // MARK: - App Target 생성
    static func makeDemoTargets(
        name: String,
        infoPlist: [String: Plist.Value] = [:],
        dependencies: [TargetDependency] = []
    ) -> Target {
        return target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "\(organizationName).\(name)", // com.yongin.pida.Sample
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["./Demo/Sources/**"],
            resources: ["./Demo/Resources/**"],
            dependencies: dependencies
        )
    }
    
    // MARK: - Dynamic Framework로 세팅할 Interface Target 생성
    static func makeInterfaceTarget(
        name: String,
        layer: Layer,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return target(
            name: "\(name)Interface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)Interface", // com.yongin.pida.Domain.SampleInferface
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./Interface/**"],
            dependencies: dependencies
        )
    }
    
    // MARK: - Static Framework로 세팅할 Implementation Target 생성
    static func makeImplementTarget(
        name: String,
        layer: Layer,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return target(
            name: "\(name)",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)", // com.yongin.pida.Domain.Sample
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./Implement/**"],
            dependencies: dependencies
        )
    }
    
    // MARK: - Test Target 생성
    static func makeTestingTarget(
        name: String,
        layer: Layer,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return target(
            name: "\(name)Testing",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(organizationName).\(layer.rawValue).\(name)Testing", // com.yongin.pida.Domain.SampleTesting
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["./Testing/**"],
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
            sources: ["./Sources/\(name)/**"],
            dependencies: dependencies
        )
    }
}
