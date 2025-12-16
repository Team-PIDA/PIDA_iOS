//
//  FlowerSpotDataImplementProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.FlowerSpot,
  dependencies: [
    .Data.FlowerSpot.Interface
  ]
)
