//
//  SearchDataImplementProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Search",
    layer: .data,
    implementDependency: [
        .Data.Search.Interface
    ]
)

