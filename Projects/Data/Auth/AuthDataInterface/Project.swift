//
//  AuthDataInterfaceProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Auth",
  layer: .data,
  interfaceDependency: [
    .Domain.Auth.Interface
  ]
)
