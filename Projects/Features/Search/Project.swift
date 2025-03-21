//
//  SearchProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "Search",
    featureInterfaceDependencies: [
        .Domain.Search.Interface
        // 필요 시, Domain Interface Dependency 추가
    ]
)
