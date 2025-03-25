//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 3/21/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Cache",
    organizationName: "com.yongin.pida",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ]),
    targets: [
        .target(
            name: "Cache",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.yongin.pida.Cache",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .InternalDependency.Shared
            ]
        )
    ]
)
