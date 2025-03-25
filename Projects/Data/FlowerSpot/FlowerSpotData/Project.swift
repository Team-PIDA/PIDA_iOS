//
//  FlowerSpotDataImplementProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "FlowerSpot",
  layer: .data,
  implementDependency: [
    .Data.FlowerSpot.Interface
  ]
)

