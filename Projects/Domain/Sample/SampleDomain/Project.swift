//
//  SampleDomainImplementProject.swift
//
//  Sample
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Sample",
    layer: .domain,
    implementDependency: [
        .Domain.Sample.Interface
    ]
)
