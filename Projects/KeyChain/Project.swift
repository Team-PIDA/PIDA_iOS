//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "KeyChain",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "KeyChain",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".KeyChain",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: []
    )
  ]
)
