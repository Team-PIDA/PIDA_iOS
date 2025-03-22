//
//  AuthDataImplementProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Auth",
  layer: .data,
  implementDependency: [
    .Data.Auth.Interface
  ]
)

