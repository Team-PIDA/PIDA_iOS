//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "ThirdParty",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "ThirdParty",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".ThirdParty",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .SPM.TCA,
        .SPM.NMap,
        .SPM.Lottie,
        .SPM.DotLottie,
      ]
    )
  ]
)
