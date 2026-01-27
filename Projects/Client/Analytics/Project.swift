//
//  Project.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Analytics,
  dependencies: [
    .SPM.TCA,
    .SPM.Mixpanel
  ]
)
