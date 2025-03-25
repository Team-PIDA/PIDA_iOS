//
//  SearchDomainImplementProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Search",
    layer: .domain,
    implementDependency: [
        .Domain.Search.Interface
    ]
)
