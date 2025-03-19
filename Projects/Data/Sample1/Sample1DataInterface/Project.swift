//
//  Sample1DataInterfaceProject.swift
//
//  Sample1
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Sample1",
    layer: .data,
    interfaceDependency: [
        .Domain.Sample1.Interface
    ]
)
