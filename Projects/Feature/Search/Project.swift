//
//  SearchProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Search,
  interfaceDependencies: [
    .Client.Search,
    .Client.FlowerSpot
  ]
)
