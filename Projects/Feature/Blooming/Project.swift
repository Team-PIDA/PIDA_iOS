//
//  BloomingProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Blooming,
  interfaceDependencies: [
    .Client.Blooming
  ]
)
