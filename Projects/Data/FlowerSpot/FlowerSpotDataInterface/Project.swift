//
//  FlowerSpotDataInterfaceProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "FlowerSpot",
  layer: .data,
  interfaceDependency: [
    .Domain.FlowerSpot.Interface
  ]
)
