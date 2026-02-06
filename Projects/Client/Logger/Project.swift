//
//  Project.swift
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Logger,
  dependencies: [
    .SPM.TCA
  ]
)
