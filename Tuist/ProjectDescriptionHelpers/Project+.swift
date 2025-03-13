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
            options: .options(
              automaticSchemesOptions: .disabled,
              defaultKnownRegions: ["ko"],
              developmentRegion: "ko",
              textSettings: .textSettings(
                indentWidth: 2,
                tabWidth: 2,
                wrapsLines: true
              )
            ),
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
        let middle = layer.rawValue
        return .init(
            name: "\(name)\(middle)Interface",
            organizationName: organizationName,
            options: .options(
              automaticSchemesOptions: .disabled,
              defaultKnownRegions: ["ko"],
              developmentRegion: "ko",
              textSettings: .textSettings(
                indentWidth: 2,
                tabWidth: 2,
                wrapsLines: true
              )
            ),
            settings: settings,
            targets: [
                .makeInterfaceTarget(
                    name: name,
                    layer: layer,
                    dependencies: interfaceDependency
                ),
                .makeTestingTarget(
                    name: name,
                    layer: layer,
                    dependencies: [.target(name: "\(name)\(middle)Interface")]
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
        let middle = layer.rawValue
        return .init(
            name: "\(name)\(middle)",
            organizationName: organizationName,
            options: .options(
              automaticSchemesOptions: .disabled,
              defaultKnownRegions: ["ko"],
              developmentRegion: "ko",
              textSettings: .textSettings(
                indentWidth: 2,
                tabWidth: 2,
                wrapsLines: true
              )
            ),
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
            options: .options(
              automaticSchemesOptions: .disabled,
              defaultKnownRegions: ["ko"],
              developmentRegion: "ko",
              textSettings: .textSettings(
                indentWidth: 2,
                tabWidth: 2,
                wrapsLines: true
              )
            ),
            settings: settings,
            targets: [
                // Example (App 실행 예제)
                .makeDemoTargets(
                    name: name,
                    dependencies: [.target(name: "\(name)Feature")]
                ),
                // Test 모듈 (Unit Test)
                .makeTestingTarget(
                    name: name,
                    layer: .feature,
                    dependencies: [.target(name: "\(name)FeatureInterface")]
                ),
                // Feature 모듈 (Static Library)
                .makeImplementTarget(
                    name: name,
                    layer: .feature,
                    dependencies: [.target(name: "\(name)FeatureInterface")]
                ),
                // Interface 모듈 (Dynamic Framework)
                .makeInterfaceTarget(
                    name: name,
                    layer: .feature,
                    dependencies: featureInterfaceDependencies
                )
            ]
        )
    }
  
  static func makePIDA(
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Project {
    return .init(
      name: "PIDA",
      organizationName: organizationName,
      options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko",
        textSettings: .textSettings(
          indentWidth: 2,
          tabWidth: 2,
          wrapsLines: true
        )
      ),
      settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
      ]),
      targets: [
        .makeApp(
          name: "PIDA",
          env: .production,
          infoPlist: infoPlist,
          dependencies: dependencies
        ),
        .makeApp(
          name: "PIDA_DEV",
          env: .development,
          infoPlist: infoPlist,
          dependencies: dependencies
        )
      ]
    )
  }
}
