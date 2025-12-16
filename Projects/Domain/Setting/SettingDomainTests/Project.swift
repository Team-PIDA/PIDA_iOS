//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildUnitTests(
  for: Domain.Setting,
  dependencies: [.Domain.Setting.Interface]
)
