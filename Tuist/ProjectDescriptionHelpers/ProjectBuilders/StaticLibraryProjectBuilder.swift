//
//  StaticLibraryProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// `Static Library` Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록
  ///   - nameSuffix: Target 이름에 추가할 접미사
  static func buildStaticLibrary<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Project {
    return buildBaseProject(
      name: name(for: module, suffix: nameSuffix),
      targets: [.buildStaticLibraryTarget(
        for: module,
        dependencies: dependencies,
        nameSuffix: nameSuffix
      )]
    )
  }
}
