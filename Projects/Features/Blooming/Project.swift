//
//  BloomingProject.swift
//
//  Blooming
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  name: "Blooming",
  featureInterfaceDependencies: [
    .Domain.Blooming.Interface
    // 필요 시, Domain Interface Dependency 추가
  ]
)
