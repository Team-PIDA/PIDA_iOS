//
//  MapDomainInterfaceProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Map",
  layer: .domain,
  interfaceDependency: [
    .InternalDependency.Core
  ]
)

