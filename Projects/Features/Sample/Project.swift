//
//  SampleProject.swift
//
//  Sample
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "Sample",
    featureInterfaceDependencies: [
        .Domain.Sample.Interface
        // 필요 시, Domain Interface Dependency 추가
    ]
)
