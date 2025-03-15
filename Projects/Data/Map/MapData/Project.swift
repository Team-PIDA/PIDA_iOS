//
//  MapDataImplementProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Map",
    layer: .data,
    implementDependency: [
        .Data.Map.Interface
    ]
)

