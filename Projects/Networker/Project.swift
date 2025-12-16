//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Networker",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "Networker",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".Networker",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .Common.Cache,
        .Common.KeyChain,
        .Common.UserDefault,
        .Common.Utility
      ]
    )
  ]
)
