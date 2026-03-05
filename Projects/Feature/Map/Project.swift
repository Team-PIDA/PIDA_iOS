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
    .Feature.Category_interface,
    .Feature.FlowerSpotDetail_interface,
    .Feature.SearchRegionList_interface,
    .Client.FlowerSpot,
    .Client.Blooming,
    .Client.Location,
    .Client.Search,
    .Client.Analytics,
    .NMapsMap,
    .NMapsGeometry
  ]
)
