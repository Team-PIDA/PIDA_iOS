//
//  SettingDataInterfaceProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Setting",
  layer: .data,
  interfaceDependency: [
    .Domain.Setting.Interface
  ]
)
