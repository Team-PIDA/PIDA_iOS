//
//  MapDomainImplementProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Map",
    layer: .domain,
    implementDependency: [
        .Domain.Map.Interface
    ]
)
