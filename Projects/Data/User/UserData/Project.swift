//
//  UserDataImplementProject.swift
//
//  User
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.User,
  dependencies: [
    .Data.User.Interface
  ]
)
