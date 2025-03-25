//
//  SearchDataInterfaceProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Search",
    layer: .data,
    interfaceDependency: [
        .Domain.Search.Interface
    ]
)
