//
//  SampleDataInterfaceProject.swift
//
//  Sample
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
    name: "Sample",
    layer: .data,
    interfaceDependency: [
        .Domain.Sample.Interface
    ]
)
