//
//  AuthProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  name: "Auth",
  featureInterfaceDependencies: [
    .Domain.Auth.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
