//
//  BloomingDataInterfaceProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.Blooming,
  dependencies: [
    // 필요한 Domain Interface 의존성 추가
    .Domain.Blooming.Interface
  ],
  nameSuffix: "Interface"
)
