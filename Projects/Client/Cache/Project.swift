//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 3/21/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Cache,
  dependencies: [
    .SPM.TCA,
    .Shared
  ]
)
