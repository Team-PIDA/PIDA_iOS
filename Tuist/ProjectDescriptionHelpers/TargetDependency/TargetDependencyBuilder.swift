//
//  TargetDependencyFactory.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/14/25.
//

import Foundation
import ProjectDescription

protocol TargetDependencyFactory { }

extension TargetDependencyFactory {
  public static func project(_ folder: Folder) -> TargetDependency {
    switch folder {
    case let .feature(feature, isInterface): buildTargetDependency(for: feature, isInterface: isInterface)
    case let .client(client): buildTargetDependency(for: client)
    case let .spm(spm): .external(name: String(describing: spm))
    }
  }
}

extension TargetDependencyFactory {
  /// `target` 타입에 따라 경로와 타겟 이름을 동적으로 생성
  /// `Projects/{root}/{module}` 형태로 생성
  fileprivate static func buildTargetDependency<T: ModuleRepresentable>(
    for target: T,
    isInterface: Bool = false
  ) -> TargetDependency {
    let root = target.root
    let module = String(describing: target) + target.root + (isInterface ? "Interface" : "")
    return .project(
      target: module,
      path: .relativeToRoot("./Projects/\(root)/\(String(describing: target))")
    )
  }
}
