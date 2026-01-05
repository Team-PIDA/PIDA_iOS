//
//  Project.swift
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Location,
  dependencies: [
    .Client.API,
    .SPM.TCA
  ]
)
