//
//  FlowerSpotDomainInterfaceProject.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildStaticLibrary(
  for: Domain.FlowerSpot,
  dependencies: [.SPM.Dependencies],
  nameSuffix: "Interface"
)
