//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DesignKit",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "DesignKit",
      destinations: .iOS,
      product: .framework,
      bundleId: organization + ".DesignKit",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [
        "UIAppFonts": [
          "Item 0": "Pretendard-SemiBold.otf"
        ]
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [.SPM.DotLottie]
    )
  ]
)
