//
//  Project.swift
//  AppDependenciesManifests
//
//  Created by 조용인 on 12/17/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "AppDependencies",
  organizationName: organization,
  settings: .default,
  targets: [
    .target(
      name: "AppDependencies",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: organization + ".AppDependencies",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .Domain.Search.Implement,
        .Domain.Setting.Implement,
        .Domain.FlowerSpot.Implement,
        .Domain.Auth.Implement,
        .Domain.User.Implement,
        .Domain.Blooming.Implement,
        
        .Data.Search.Implement,
        .Data.Setting.Implement,
        .Data.FlowerSpot.Implement,
        .Data.Auth.Implement,
        .Data.User.Implement,
        .Data.Blooming.Implement,
        .Common.Networker,
        .SPM.TCA
      ]
    )
  ]
)
