//
//  SearchRegionListProject.swift
//
//  SearchRegionList
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.SearchRegionList,
  interfaceDependencies: [
    .Client.Search,
    .Client.FlowerSpot,
    .Client.Analytics
  ]
)
