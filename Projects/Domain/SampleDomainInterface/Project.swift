//
//  SampleDomainInterfaceProject.swift
//
//  Sample
//
//  Created by yongin
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

