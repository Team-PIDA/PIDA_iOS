//
//  MapDataInterfaceProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Map",
    layer: .data,
    interfaceDependency: [
        .Domain.Map.Interface
    ]
)
