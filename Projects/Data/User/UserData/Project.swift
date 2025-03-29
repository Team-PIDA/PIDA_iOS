//
//  UserDataImplementProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeImplementProject(
  name: "User",
  layer: .data,
  implementDependency: [
    .Data.User.Interface
  ]
)

