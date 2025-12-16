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
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "UserDefault",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".UserDefault",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: []
    )
  ]
)
