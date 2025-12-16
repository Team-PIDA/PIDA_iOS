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
    .Domain.FlowerSpot.Interface,
    .Domain.Blooming.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
