//
//  SettingDataInterfaceProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.Setting,
  dependencies: [
    // 필요한 Domain Interface 의존성 추가
    .Domain.Setting.Interface
  ],
  nameSuffix: "Interface"
)
