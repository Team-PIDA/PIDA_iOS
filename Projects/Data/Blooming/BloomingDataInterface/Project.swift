//
//  BloomingDataInterfaceProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "Blooming",
  layer: .data,
  interfaceDependency: [
    .Domain.Blooming.Interface
  ]
)
