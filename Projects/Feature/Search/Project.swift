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
    .Domain.Search.Interface,
    .Domain.FlowerSpot.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
