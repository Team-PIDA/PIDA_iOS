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
      product: .staticLibrary,
      bundleId: organization + ".DesignKit",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .SPM.DotLottie,
        .Shared
      ],
      settings: .settings(
        base: [
          "ENABLE_PREVIEWS": "YES",  // SwiftUI Preview 지원
          "ENABLE_BITCODE": "NO"     // Static library는 bitcode 비활성화
        ]
      )
    ),
  ],
  resourceSynthesizers: [
    .assets(),
    .strings(),
    .fonts()
  ]
)
