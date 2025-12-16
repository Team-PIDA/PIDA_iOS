//
//  BaseProjectBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Project {
  /// 프로젝트 이름 생성 (`ModuleRepresentable` + 접미사)
  static func name<T: ModuleRepresentable>(
    for module: T,
    suffix: String = ""
  ) -> String {
    /// 예: `Sample`+ `Feature` + `Interface`
    return String(describing: module) + module.layer + suffix
  }
  
  /// 공통 Project 초기화
  static func buildBaseProject(
    name: String,
    targets: [Target]
  ) -> Project {
    return .init(
      name: name,
      organizationName: organization,
      options: .default,
      settings: .default,
      targets: targets
    )
  }
}
