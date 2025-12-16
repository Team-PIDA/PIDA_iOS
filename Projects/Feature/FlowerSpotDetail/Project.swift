//
//  FlowerSpotDetailProject.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.FlowerSpotDetail,
  interfaceDependencies: [
    .Domain.FlowerSpot.Interface,
    .Domain.Blooming.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
