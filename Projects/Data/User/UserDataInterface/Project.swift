//
//  UserDataInterfaceProject.swift
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
    // 필요한 Domain Interface 의존성 추가
    .Domain.User.Interface
  ],
  nameSuffix: "Interface"
)
