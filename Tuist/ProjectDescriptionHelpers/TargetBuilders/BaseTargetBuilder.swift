//
//  BaseTargetBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

extension Target {
  /// 특정 모듈을 위한 Target을 생성하는 공통 메소드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - product: 생성할 Target의 `Product` 타입 (예: `.framework`, `.staticLibrary`, `.unitTests`)
  ///   - nameSuffix: Target 이름에 추가할 접미사 (기본값: "")
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func buildBaseTarget<T: ModuleRepresentable>(
    for module: T,
    product: Product,
    nameSuffix: String = "",
    infoPlist: [String: Plist.Value] = [:],
    resources: [ResourceFileElement] = [],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let targetName = String(describing: module) + module.layer + nameSuffix
    let sourcesPath = module is Feature ? "./\(targetName)/Sources/**": "./Sources/**"
    
    return target(
      name: targetName,
      destinations: .iOS,
      product: product,
      bundleId: "\(organization).\(targetName)",
      deploymentTargets: .iOS("18.0"),
      infoPlist: infoPlist == [:] ? .default : .extendingDefault(with: infoPlist),
      sources: ["\(sourcesPath)"],
      resources: resources.isEmpty ? nil : .resources(resources),
      dependencies: dependencies
    )
  }
}
