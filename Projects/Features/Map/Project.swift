//
//  MapProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  name: "Map",
  featureInterfaceDependencies: [
    .Domain.FlowerSpot.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
