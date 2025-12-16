//
//  SearchDataImplementProject.swift
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
    .Data.Search.Interface
  ]
)
