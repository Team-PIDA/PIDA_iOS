//
//  Project.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInternalFramework(
  name: "Core",
  dependencies: [
    .CoreTarget.Networker,
    .CoreTarget.DesignKit
  ]
)
