//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 3/13/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildApp(
  dependencies: [
    .Feature.Map,
    .Feature.Search,
    .Feature.Setting,
    .Feature.FlowerSpotDetail,
    .Feature.Auth,
    .Feature.Blooming,
    
    .Domain.Search.Implement,
    .Domain.Setting.Implement,
    .Domain.FlowerSpot.Implement,
    .Domain.Auth.Implement,
    .Domain.User.Implement,
    .Domain.Blooming.Implement,
    
    .Data.Search.Implement,
    .Data.Setting.Implement,
    .Data.FlowerSpot.Implement,
    .Data.Auth.Implement,
    .Data.User.Implement,
    .Data.Blooming.Implement
  ]
)
