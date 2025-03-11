//
//  Project+.swift
//  Config
//
//  Created by 조용인 on 3/8/25.
//

import Foundation
import ProjectDescription

public extension Project {
    static let organizationName = "com.yongin.pida"
    
    // 단독으로 사용하는 Framework 모듈 (ex. Networker, DesignKit 등 등)
    static func makeInternalFramework(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let settings: Settings = .settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ])
        return .init(
            name: name,
            organizationName: organizationName,
            settings: settings,
            targets: [
                .makeInternalFrameworkTarget(
                    name: name,
                    dependencies: dependencies
                )
            ]
        )
    }
    
    // A Interface 모듈 + Testing 포함
    static func makeInterfaceProject(
        name: String,
        layer: Layer,
        interfaceDependency: [TargetDependency] = []
    ) -> Project {
        let settings: Settings = .settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ])
        return .init(
            name: name,
            organizationName: organizationName,
            settings: settings,
            targets: [
                .makeInterfaceTarget(
                    name: name,
                    layer: layer,
                    dependencies: interfaceDependency
                ),
                .makeTestingTarget(
                    name: "\(name)Testing",
                    layer: layer,
                    dependencies: [.target(name: "\(name)Interface")]
                )
            ]
        )
    }
    
    // A Interface를 Dependency로 갖는 A 구현체 모듈
    static func makeImplementProject(
        name: String,
        layer: Layer,
        implementDependency: [TargetDependency] = []
    ) -> Project {
        let settings: Settings = .settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ])
        return .init(
            name: name,
            organizationName: organizationName,
            settings: settings,
            targets: [
                .makeImplementTarget(
                    name: name,
                    layer: layer,
                    dependencies: implementDependency // Interface는 필수로 dependency에 추가
                ),
            ]
        )
    }
    
    static func makeFeature(
        name: String,
        featureInterfaceDependencies: [TargetDependency] = []
    ) -> Project {
        let settings: Settings = .settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ])
        return .init(
            name: name,
            organizationName: organizationName,
            settings: settings,
            targets: [
                // Example (App 실행 예제)
                .makeDemoTargets(
                    name: "\(name)Demo",
                    dependencies: [.target(name: name)]
                ),
                // Test 모듈 (Unit Test)
                .makeTestingTarget(
                    name: "\(name)UnitTests",
                    layer: .features,
                    dependencies: [.target(name: "\(name)Interface")]
                ),
                // Feature 모듈 (Static Library)
                .makeImplementTarget(
                    name: name,
                    layer: .features,
                    dependencies: [.target(name: "\(name)Interface")]
                ),
                // Interface 모듈 (Dynamic Framework)
                .makeInterfaceTarget(
                    name: name,
                    layer: .features,
                    dependencies: featureInterfaceDependencies
                )
            ]
        )
    }
    
}
