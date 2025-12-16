//
//  AuthDomainInterfaceProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.Auth,
  dependencies: [.SPM.Dependencies],
  nameSuffix: "Interface"
)
