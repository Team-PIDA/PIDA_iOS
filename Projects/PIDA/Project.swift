//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 3/13/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makePIDA(
  infoPlist: [
    "CFBundleDevelopmentRegion": "ko_KR",
    "CFBundleShortVersionString": "0.9",
    "CFBundleVersion": "1",
    "CFBundleIconName": "AppIcon",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
      "UIApplicationSupportsMultipleScenes": false,
      "UISceneConfigurations": []
    ]
  ],
  dependencies: [
    .Features.Sample,
    .Data.Sample.Implement,
    .Domain.Sample.Implement
  ]
)
