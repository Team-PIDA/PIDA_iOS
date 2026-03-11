//
//  Project.swift
//  APIManifests
//
//  Created by PIDA on 3/11/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Category,
  dependencies: [
    .Client.API,
    .SPM.TCA
  ]
)
