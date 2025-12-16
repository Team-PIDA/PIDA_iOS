//
//  FlowerSpotDataInterfaceProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.FlowerSpot,
  dependencies: [
    // 필요한 Domain Interface 의존성 추가
    .Domain.FlowerSpot.Interface
  ],
  nameSuffix: "Interface"
)
