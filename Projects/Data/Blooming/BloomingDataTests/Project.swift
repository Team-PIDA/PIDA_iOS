//
//  Project.swift
//  BloomingDataInterfaceManifests
//
//  Created by 조용인 on 12/16/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildUnitTests(
  for: Data.Blooming,
  dependencies: [
    .Data.Blooming.Interface
  ]
)
