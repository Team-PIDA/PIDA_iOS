//
//  AppProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// `App Project`를 생성하는 메서드
  ///
  /// - Parameters:
  ///  - dependencies: App Target이 의존하는 TargetDependency 목록
  static func buildApp(
    dependencies: [TargetDependency] = []
  ) -> Project {
    return buildBaseProject(
      name: "PIDA",
      targets: [
        .buildAppTarget(name: "PIDA", scheme: .release, with: dependencies),
        .buildAppTarget(name: "PIDev", scheme: .dev, with: dependencies)
      ]
    )
  }
}
    
