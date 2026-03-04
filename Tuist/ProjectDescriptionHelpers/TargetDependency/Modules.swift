//
//  Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public protocol ModuleRepresentable { var root: String { get } }
extension ModuleRepresentable { public var root: String { String(describing: Self.self) } }

public enum Folder {
  case feature(Feature, Bool)
  case client(Client)
  case spm(SPM)
}

public enum Feature: ModuleRepresentable {
  case Category
  case Map
  case Search
  case Setting
  case FlowerSpotDetail
  case Auth
  case Blooming
  case SearchRegionList
}

public enum Client: ModuleRepresentable {
  case API
  case Cache
  case Search
  case FlowerSpot
  case Auth
  case User
  case Blooming
  case Location
  case Push
  case DeepLink
  case Analytics
}

public enum SPM: ModuleRepresentable {
  case ComposableArchitecture
  case DotLottie
  case FirebaseCore
  case FirebaseMessaging
  case Mixpanel
}
