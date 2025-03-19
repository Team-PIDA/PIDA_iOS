//
//  Sample1DataImplementProject.swift
//
//  Sample1
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
    name: "Sample1",
    layer: .data,
    implementDependency: [
        .Data.Sample1.Interface
    ]
)

