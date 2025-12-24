//
//  Project.swift
//  SharedManifests
//
//  Created by 조용인 on 12/19/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Shared",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "Shared",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: organization + ".Shared",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: []
    )
  ]
)
