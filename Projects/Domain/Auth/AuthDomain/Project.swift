//
//  AuthDomainImplementProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.Auth,
  dependencies: [.Domain.Auth.Interface]
)
