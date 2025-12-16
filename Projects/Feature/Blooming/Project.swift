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
    .Domain.Blooming.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
