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
    public static let NMap = Self.project(.spm(.NMapsMap))
    public static let DotLottie = Self.project(.spm(.DotLottie))
  }
}

extension TargetDependency {
  // XCFramework 지원
  public struct XCFrameworks {
    /// XCFramework를 동적 이름으로 생성
    /// - Parameter name: XCFramework 이름
    /// - Returns: XCFramework TargetDependency
    public static func xcframework(named name: String) -> TargetDependency {
      .xcframework(path: .relativeToRoot("Frameworks/\(name).xcframework"))
    }
  }
}
