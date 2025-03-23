//
//  SettingDataImplementProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Setting",
  layer: .data,
  implementDependency: [
    .Data.Setting.Interface
  ]
)

