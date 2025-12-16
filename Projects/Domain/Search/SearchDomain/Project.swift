//
//  SearchDomainImplementProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.Search,
  dependencies: [.Domain.Search.Interface]
)
