//
//  SearchDomainInterfaceProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Search",
    layer: .domain,
    interfaceDependency: [
        .InternalDependency.Core
    ]
)

