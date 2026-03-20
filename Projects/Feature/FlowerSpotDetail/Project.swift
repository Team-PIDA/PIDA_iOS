//
//  FlowerSpotDetailProject.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.FlowerSpotDetail,
  interfaceDependencies: [
    .Client.FlowerSpot,
    .Client.Blooming,
    .Client.Category,
    .Client.Cache,
    .Client.Analytics,
    .NMapsMap,
    .NMapsGeometry
  ]
)
