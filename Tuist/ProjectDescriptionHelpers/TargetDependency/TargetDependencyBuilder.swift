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
  public static func project(_ module: Module) -> TargetDependency {
    switch module {
    case let .feature(feature):
      return buildTargetDependency(for: feature)
      
    case let .domain(domain, isInterface):
      if let isInterface = isInterface { return buildTargetDependency(for: domain, isInterface: isInterface) }
      return buildTargetDependency(for: domain)
      
    case let .data(data, isInterface):
      if let isInterface = isInterface { return buildTargetDependency(for: data, isInterface: isInterface) }
      return buildTargetDependency(for: data)
      
    case let .common(module):
      return buildCommonTargetDependency(for: module)
      
    case let .spm(spm):
      return .external(name: spm.rawValue)
    }
  }
}

extension TargetDependencyFactory {
  /// Feature/Domain/Data 전용 의존성 생성
  /// `Projects/Domain/Sample/SampleDomainInterface` 또는 `Projects/Domain/Sample/SampleDomain`
  fileprivate static func buildTargetDependency<T: ModuleRepresentable>(
    for target: T,
    isInterface: Bool = false
  ) -> TargetDependency {
    let suffix = isInterface ? "Interface" : ""
    let targetName = String(describing: target) + target.layer + suffix
    let addPath = target is Feature ? "" : "/\(targetName)"
    return .project(
      target: targetName,
      path: .relativeToRoot("./Projects/\(target.layer)/\(target)" + addPath)
    )
  }
  
  /// 특정 Common 공통 모듈 의존성 생성
  fileprivate static func buildCommonTargetDependency<T: ModuleRepresentable>(
    for common: T
  ) -> TargetDependency {
    return .project(
      target: common.layer,
      path: .relativeToRoot("./Projects/" + "\(common.layer)")
    )
  }
}
