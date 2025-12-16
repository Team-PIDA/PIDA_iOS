//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Utility",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "Utility",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".Utility",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: []
    )
  ]
)
