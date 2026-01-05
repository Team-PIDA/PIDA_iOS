//
//  MapProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Map,
  interfaceDependencies: [
    .Client.FlowerSpot,
    .Client.Blooming,
    .Client.Location,
    .SPM.NMap
  ]
)
