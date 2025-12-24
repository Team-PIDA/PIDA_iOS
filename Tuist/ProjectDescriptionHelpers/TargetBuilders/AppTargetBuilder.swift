//
//  AppTargetBuilder.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

public extension Target {
  /// `App Target`을 생성하는 메소드
  ///
  /// - Parameters:
  ///   - name: Target 이름
  ///   - scheme: 빌드 스킴
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func buildAppTarget(
    name: String,
    scheme: Scheme,
    with dependencies: [TargetDependency] = []
  ) -> Target {
    return target(
      name: name,
      destinations: [.iPhone],
      product: .app,
      bundleId: scheme.BUNDLE_ID,
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: scheme.INFO_PLIST),
      sources: ["Sources/**"],
      resources: [.glob(pattern: "Resources/**", excluding: scheme.GLOB_EXCLUDING)],
      entitlements: .file(path: .relativeToRoot(scheme.ENTITLEMENTS_PATH)),
      scripts: scheme.SCRIPT,
      dependencies: dependencies,
      settings: scheme.SETTING
    )
  }
}
