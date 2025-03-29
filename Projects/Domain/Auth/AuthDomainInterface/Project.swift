//
//  AuthDomainInterfaceProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Auth",
  layer: .domain,
  interfaceDependency: [
    .InternalDependency.Core
  ]
)

