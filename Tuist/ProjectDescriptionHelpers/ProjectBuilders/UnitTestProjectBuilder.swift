//
//  UnitTestProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// `Unit Test` Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: 테스트 타겟이 의존하는 다른 Target들의 목록
  static func buildUnitTests<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = []
  ) -> Project {
    let moduleTest = Target.buildUnitTestTarget(
      for: module,
      dependencies: [.target(name: name(for: module, suffix: "Testing"))]
    )
    
    let moduleTesting = Target.buildStaticLibraryTarget(
      for: module,
      dependencies: dependencies,
      nameSuffix: "Testing"
    )
    
    return buildBaseProject(
      name: name(for: module, suffix: "Tests"),
      targets: [moduleTesting, moduleTest]
    )
  }
}
