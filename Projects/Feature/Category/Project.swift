//
//  CategoryProject.swift
//
//  Category
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Category,
  interfaceDependencies: [
    .Client.FlowerSpot,
    .Client.Analytics
  ]
)
