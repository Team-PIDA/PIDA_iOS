//
//  UserDataInterfaceProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInterfaceProject(
  name: "User",
  layer: .data,
  interfaceDependency: [
    .Domain.User.Interface
  ]
)
