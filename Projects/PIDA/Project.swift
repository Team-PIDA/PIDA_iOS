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
    ],
    "NSLocationWhenInUseUsageDescription": "지도에서 내 위치를 확인하여 길찾기, 네비게이션 기능을 이용하기 위해 권한이 필요합니다.(필수권한)",
    "NMCLIENTID": "$(NM_CLIENT_ID)"
  ],
  dependencies: [
    .Features.Map.Implement,
    
    .Features.Search.Implement,
    .Domain.Search.Implement,
    .Data.Search.Implement,
    
    .Features.Setting.Implement,
    .Domain.Setting.Implement,
    .Data.Setting.Implement,
    
    .Data.FlowerSpot.Implement,
    .Domain.FlowerSpot.Implement,

    .Features.Auth.Implement,
    .Domain.Auth.Implement,
    .Data.Auth.Implement,
    
    .Data.User.Implement,
    .Domain.User.Implement,

    .Features.Blooming.Implement,
    .Domain.Blooming.Implement,
    .Data.Blooming.Implement
  ]
)
