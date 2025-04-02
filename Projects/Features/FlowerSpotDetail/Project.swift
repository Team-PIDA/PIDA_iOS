//
//  FlowerSpotDetailProject.swift
//
//  FlowerSpotDetail
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  name: "FlowerSpotDetail",
  featureInterfaceDependencies: [
    .Domain.FlowerSpot.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
