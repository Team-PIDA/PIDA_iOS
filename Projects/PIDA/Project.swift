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
    .Client.Push,
    .Client.User,
    .Client.Location,
    .Client.DeepLink,
    .Client.Analytics,
    .SPM.FirebaseCore,
    .SPM.FirebaseMessaging,
    .Feature.SearchRegionList
  ]
)
