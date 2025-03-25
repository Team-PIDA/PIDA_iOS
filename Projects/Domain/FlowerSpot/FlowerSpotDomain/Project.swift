//
//  FlowerSpotDomainImplementProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "FlowerSpot",
  layer: .domain,
  implementDependency: [
    .Domain.FlowerSpot.Interface
  ]
)
