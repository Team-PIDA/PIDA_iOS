//
//  AuthProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Auth,
  interfaceDependencies: [
    .Client.Auth,
    .Client.User,
    .Client.Blooming
  ]
)
