//
//  UserDomainInterfaceProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "User",
  layer: .domain,
  interfaceDependency: [
    .InternalDependency.Core
  ]
)

