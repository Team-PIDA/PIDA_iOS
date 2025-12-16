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
    .Domain.Auth.Interface,
    .Domain.User.Interface,
    .Domain.Blooming.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
