//
//  Domain.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let DomainPath: String = "Projects/Domain/\(name)"


let domainTemplate = Template(
  description: "Domain 템플릿",
  attributes: [name, author],
  items: [
    // Interface Project
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Project.swift",
      templatePath: "domain_interface_project.stencil"
    ),
    // Implementation Project
    .file(
      path: "\(DomainPath)/\(name)Domain/Project.swift",
      templatePath: "domain_implement_project.stencil"
    ),
    // Tests Project
    .file(
      path: "\(DomainPath)/\(name)DomainTests/Project.swift",
      templatePath: "domain_tests_project.stencil"
    ),
    // Repository Interface
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/Repository/\(name)Repository.swift",
      templatePath: "domain_repository.stencil"
    ),
    // UseCase Interface
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/UseCases/\(name)UseCase.swift",
      templatePath: "domain_usecase_interface.stencil"
    ),
    // Entity
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/Entity/\(name)Entity.swift",
      templatePath: "domain_entity.stencil"
    ),
    // Dependency Key
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/DependencyKey/\(name)UseCaseKey.swift",
      templatePath: "domain_dependencyKey.stencil"
    ),
    // UseCase Implementation
    .file(
      path: "\(DomainPath)/\(name)Domain/Sources/\(name)UseCaseImpl.swift",
      templatePath: "domain_usecase_implement.stencil"
    ),
    // UseCase Tests
    .file(
      path: "\(DomainPath)/\(name)DomainTests/Sources/\(name)UseCaseTests.swift",
      templatePath: "domain_usecase_test.stencil"
    ),
    // Testing에 사용되는 Mock or Stub
    .file(
      path: "\(DomainPath)/\(name)DomainTesting/Sources/\(name)UseCaseMock.swift",
      templatePath: "domain_testing_mock.stencil"
    )
  ]
)
