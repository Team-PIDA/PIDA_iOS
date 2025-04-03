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
  organizationName: "com.yongin.pida",
  settings: .settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
  ]),
  targets: [
    .target(
      name: "ThirdParty",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yongin.pida.ThirdParty",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .ThirdParty.TCA,
        .ThirdParty.NMaps,
        .ThirdParty.Lottie
      ]
    )
  ]
)
