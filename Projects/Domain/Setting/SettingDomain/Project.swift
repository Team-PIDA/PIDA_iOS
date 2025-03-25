//
//  SettingDomainImplementProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Setting",
  layer: .domain,
  implementDependency: [
    .Domain.Setting.Interface
  ]
)
