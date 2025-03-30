//
//  BloomingDomainInterfaceProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Blooming",
  layer: .domain,
  interfaceDependency: [
    .InternalDependency.Core
  ]
)

