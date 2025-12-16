//
//  AuthDataInterfaceProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.Auth,
  dependencies: [
    // 필요한 Domain Interface 의존성 추가
    .Domain.Auth.Interface
  ],
  nameSuffix: "Interface"
)
