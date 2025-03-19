//
//  Sample1DomainImplementProject.swift
//
//  Sample1
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Sample1",
    layer: .domain,
    implementDependency: [
        .Domain.Sample1.Interface
    ]
)
