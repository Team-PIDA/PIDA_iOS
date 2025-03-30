//
//  BloomingDataImplementProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Blooming",
  layer: .data,
  implementDependency: [
    .Data.Blooming.Interface
  ]
)

