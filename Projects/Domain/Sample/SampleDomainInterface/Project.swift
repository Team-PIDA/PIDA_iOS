//
//  SampleDomainInterfaceProject.swift
//
//  Sample
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Sample",
    layer: .domain,
    interfaceDependency: [
        .InternalDependency.Core
    ]
)

