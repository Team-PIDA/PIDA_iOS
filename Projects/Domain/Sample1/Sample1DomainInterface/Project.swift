//
//  Sample1DomainInterfaceProject.swift
//
//  Sample1
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Sample1",
    layer: .domain,
    interfaceDependency: [
        .InternalDependency.Core
    ]
)

