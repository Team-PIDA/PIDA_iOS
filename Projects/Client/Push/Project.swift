//
//  Project.swift
//  PushClient
//
//  Created by Claude on 1/9/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Client.Push,
  dependencies: [
    .SPM.TCA,
    .SPM.FirebaseMessaging
  ]
)
