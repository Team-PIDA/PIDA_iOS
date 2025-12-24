//
//  UnitTestTargetBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Target {
  /// `Unit Test` 타겟 생성
  ///
  /// - Parameters:
  ///  - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///  - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func buildUnitTestTarget<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = []
  ) -> Target {
    buildBaseTarget(
      for: module,
      product: .unitTests,
      nameSuffix: "Tests",
      dependencies: dependencies
    )
  }
}
