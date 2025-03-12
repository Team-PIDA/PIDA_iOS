//
//  SampleDomainImplementProject.swift
//
//  Sample
//
//  Created by yongin
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
