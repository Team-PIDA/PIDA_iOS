//
//  UserDomainInterfaceProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.User,
  dependencies: [.SPM.Dependencies],
  nameSuffix: "Interface"
)

