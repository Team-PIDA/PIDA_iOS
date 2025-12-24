//
//  Project.swift
//  APIManifests
//
//  Created by 조용인 on 12/19/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Search,
  dependencies: [
    .Client.API,
    .Client.Cache,
    .SPM.TCA
  ]
)
