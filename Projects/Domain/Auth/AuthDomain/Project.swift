//
//  AuthDomainImplementProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "Auth",
  layer: .domain,
  implementDependency: [
    .Domain.Auth.Interface
  ]
)
