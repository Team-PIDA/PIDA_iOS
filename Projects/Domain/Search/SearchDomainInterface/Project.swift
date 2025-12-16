//
//  SearchDomainInterfaceProject.swift
//
//  Search
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.Search,
  dependencies: [.SPM.Dependencies],
  nameSuffix: "Interface"
)

