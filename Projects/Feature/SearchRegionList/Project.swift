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
    .Client.FlowerSpot
    // 필요한 Domain Interface 의존성 추가
  ]
)
