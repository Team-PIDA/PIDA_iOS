//
//  SettingDataImplementProject.swift
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
    .Data.Setting.Interface
  ]
)
