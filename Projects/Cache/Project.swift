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
    organizationName: organization,
    settings: .default,
    targets: [
        .target(
            name: "Cache",
            destinations: .iOS,
            product: .framework,
            bundleId: organization + ".Cache",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
              .Common.KeyChain,
              .Common.UserDefault,
              .Common.Utility
            ]
        )
    ]
)
