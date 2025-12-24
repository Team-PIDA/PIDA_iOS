//
//  StaticLibraryTargetBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Target {
  /// `Static Library` 타입의 Target을 생성하는 메소드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  ///   - nameSuffix: Target 이름에 추가할 접미사 (기본값: "")
  static func buildStaticLibraryTarget<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Target {
    buildBaseTarget(
      for: module,
      product: .staticLibrary,
      nameSuffix: nameSuffix,
      dependencies: dependencies
    )
  }
}
