//
//  DemoTargetBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Target {
  /// `Demo Target`을 생성하는 메소드
  ///
  /// - Parameters:
  ///  - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///  - infoPlist: Target의 Info.plist 설정 (기본값: 빈 딕셔너리)
  ///  - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: 빈 배열)
  static func buildDemoTarget<T: ModuleRepresentable>(
    for module: T,
    infoPlist: [String: Plist.Value] = [:],
    resources: [ResourceFileElement] = [],
    dependencies: [TargetDependency] = []
  ) -> Target {
    return buildBaseTarget(
      for: module,
      product: .app,
      nameSuffix: "Demo",
      infoPlist: infoPlist,
      resources: resources,
      dependencies: dependencies
    )
  }
}
