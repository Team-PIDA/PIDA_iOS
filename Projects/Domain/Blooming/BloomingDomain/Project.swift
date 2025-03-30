//
//  BloomingDomainImplementProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Blooming",
  layer: .domain,
  implementDependency: [
    .Domain.Blooming.Interface
  ]
)
