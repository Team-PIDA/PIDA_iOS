//
//  DependencyComponent.swift
//  Config
//
//  Created by 조용인 on 3/9/25.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public struct Feature: TargetDependencyFactory {
    public static let Map = Self.project(.feature(.Map, false))
    public static let Search = Self.project(.feature(.Search, false))
    public static let Setting = Self.project(.feature(.Setting, false))
    public static let FlowerSpotDetail = Self.project(.feature(.FlowerSpotDetail, false))
    public static let FlowerSpotDetail_interface = Self.project(.feature(.FlowerSpotDetail, true))
    public static let Auth = Self.project(.feature(.Auth, false))
    public static let Blooming = Self.project(.feature(.Blooming, false))
    public static let SearchRegionList = Self.project(.feature(.SearchRegionList, false))
    public static let SearchRegionList_interface = Self.project(.feature(.SearchRegionList, true))
  }
}

extension TargetDependency {
  public struct Client: TargetDependencyFactory {
    public static let Cache = Self.project(.client(.Cache))
    public static let API = Self.project(.client(.API))
    public static let Search = Self.project(.client(.Search))
    public static let FlowerSpot = Self.project(.client(.FlowerSpot))
    public static let Auth = Self.project(.client(.Auth))
    public static let User = Self.project(.client(.User))
    public static let Blooming = Self.project(.client(.Blooming))
    public static let Location = Self.project(.client(.Location))
    public static let Push = Self.project(.client(.Push))
    public static let DeepLink = Self.project(.client(.DeepLink))
    public static let Analytics = Self.project(.client(.Analytics))
  }
}

extension TargetDependency {
  public static let Shared = project(target: "Shared", path: .relativeToRoot("./Projects/Shared"))
}


extension TargetDependency {
  public static let DesignKit = project(target: "DesignKit", path: .relativeToRoot("./Projects/DesignKit"))
}

extension TargetDependency {
  public struct SPM: TargetDependencyFactory {
    public static let TCA = Self.project(.spm(.ComposableArchitecture))
    public static let DotLottie = Self.project(.spm(.DotLottie))
    public static let FirebaseCore = Self.project(.spm(.FirebaseCore))
    public static let FirebaseMessaging = Self.project(.spm(.FirebaseMessaging))
    public static let Mixpanel = Self.project(.spm(.Mixpanel))
  }
}

extension TargetDependency {
  public static let NMapsMap = xcframework(path: .relativeToRoot("Frameworks/NMapsMap.xcframework"))
  public static let NMapsGeometry = xcframework(path: .relativeToRoot("Frameworks/NMapsGeometry.xcframework"))
}
