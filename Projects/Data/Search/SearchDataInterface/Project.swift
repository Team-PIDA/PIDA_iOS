//
//  SearchDataInterfaceProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Data.Search,
  dependencies: [
    // 필요한 Domain Interface 의존성 추가
    .Domain.Search.Interface
  ],
  nameSuffix: "Interface"
)
