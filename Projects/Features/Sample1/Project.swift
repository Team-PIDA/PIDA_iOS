//
//  Sample1Project.swift
//
//  Sample1
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "Sample1",
    featureInterfaceDependencies: [
        .Domain.Sample1.Interface
        // 필요 시, Domain Interface Dependency 추가
    ]
)
