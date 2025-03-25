//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 3/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "UserDefault",
  organizationName: "com.yongin.pida",
  settings: .settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
  ]),
  targets: [
    .target(
      name: "UserDefault",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yongin.pida.UserDefault",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: []
    )
  ]
)
