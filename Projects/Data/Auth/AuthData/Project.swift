//
//  AuthDataImplementProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.Auth,
  dependencies: [
    .Data.Auth.Interface
  ]
)
