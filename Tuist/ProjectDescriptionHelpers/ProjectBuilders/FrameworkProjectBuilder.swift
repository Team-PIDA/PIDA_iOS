//
//  FrameworkProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// `(Dynamic) Framework` Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func buildFramework<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Project {
    return buildBaseProject(
      name: name(for: module, suffix: nameSuffix),
      targets: [.buildFrameworkTarget(for: module, dependencies: dependencies, nameSuffix: nameSuffix)]
    )
  }
}
