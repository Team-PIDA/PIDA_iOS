//
//  Project.swift
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.DeepLink,
  dependencies: [
    .SPM.TCA
  ]
)
