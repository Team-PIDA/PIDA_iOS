//
//  FeatureProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// `Feature` 모듈을 위한 `Interface`, `Demo`, `Implement`, `Unit Test` Target들을 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - interfaceDependencies: Interface 타겟이 의존하는 다른 Target들의 목록 (기본값: [])
  ///   - implementDependencies: Implement 타겟이 의존하는 다른 Target들의 목록 (기본값: [])
  ///
  /// - `Feature Interface`: Feature 모듈의 State/Action을 포함하는 `Static Library` Target
  /// - `Feature`: Feature 모듈의 Reducer 구현을 포함하는 `Static Library` Target
  /// - `Feature Unit Test`: Feature 모듈의 단위 테스트를 포함하는 Target
  /// - `Demo`: Feature 모듈을 실행할 수 있는 앱 Target
  static func buildFeature<T: ModuleRepresentable>(
    for module: T,
    interfaceDependencies: [TargetDependency] = [],
    implementDependencies: [TargetDependency] = []
  ) -> Project {
    let featureName = name(for: module)
    let interfaceName = name(for: module, suffix: "Interface")
    let testingName = name(for: module, suffix: "Testing")
    
    let demo = Target.buildDemoTarget(
      for: module,
      dependencies: [.target(name: featureName)]
    )
    let featureTests = Target.buildUnitTestTarget(
      for: module,
      dependencies: [.target(name: testingName)],
    )
    
    let featureTesting = Target.buildStaticLibraryTarget(
      for: module,
      dependencies: [.target(name: interfaceName)],
      nameSuffix: "Testing"
    )
    let feature = Target.buildStaticLibraryTarget(
      for: module,
      dependencies: [.target(name: interfaceName)]
    )
    
    let featureInterface = Target.buildStaticLibraryTarget(
      for: module,
      dependencies: interfaceDependencies + [.DesignKit],
      nameSuffix: "Interface"
    )
    return buildBaseProject(
      name: featureName,
      targets: [featureInterface, feature, featureTesting, featureTests, demo]
    )
  }
}

