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
    .Client.User,
    .Client.Auth
  ]
)
