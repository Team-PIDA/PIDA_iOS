//
//  SampleDataImplementProject.swift
//
//  Sample
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Sample",
    layer: .data,
    implementDependency: [
        .Data.Sample.Interface
    ]
)

