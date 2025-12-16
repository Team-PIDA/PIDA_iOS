//
//  SettingProject.swift
//
//  Setting
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Setting,
  interfaceDependencies: [
    .Domain.Setting.Interface,
    .Domain.User.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
