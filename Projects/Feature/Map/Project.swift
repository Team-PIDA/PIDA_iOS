//
//  MapProject.swift
//
//  Map
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.buildFeature(
  for: Feature.Map,
  interfaceDependencies: [
    .Feature.FlowerSpotDetail_interface,
    .Feature.SearchRegionList_interface,
    .Client.FlowerSpot,
    .Client.Blooming,
    .Client.Location,
    .SPM.NMap
  ]
)
