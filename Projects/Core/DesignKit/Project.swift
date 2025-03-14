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
  organizationName: "com.yongin.pida",
  settings: .settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
  ]),
  targets: [
    .makeDemoTargets(
      name: "DesignKit",
      dependencies: [.target(name: "DesignKit")]
    ),
    .target(
      name: "DesignKit",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yongin.pida.DesignKit",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [
        "UIAppFonts": [
          "Item 0": "Pretendard-SemiBold.otf"
        ]
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .InternalDependency.Shared
      ]
    )
  ]
)
