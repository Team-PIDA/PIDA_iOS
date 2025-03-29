//
//  UserDomainImplementProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "User",
  layer: .domain,
  implementDependency: [
    .Domain.User.Interface
  ]
)
