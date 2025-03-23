//
//  SettingDomainInterfaceProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Setting",
  layer: .domain,
  interfaceDependency: [
    .InternalDependency.Core
  ]
)

