//
//  SettingDomainImplementProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.Setting,
  dependencies: [.Domain.Setting.Interface]
)
