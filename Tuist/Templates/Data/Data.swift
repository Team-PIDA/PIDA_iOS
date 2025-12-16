//
//  Data.swift
//  PIDA_iOSManifests
//
//  Created by 조용인 on 3/12/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")

/// 파일 경로
fileprivate let DataPath: String = "Projects/Data/\(name)"

let dataTemplate = Template(
  description: "Data 모듈 템플릿",
  attributes: [
    name,
    author
  ],
  items: [
    // Implementation Project
    .file(
      path: "\(DataPath)/\(name)Data/Project.swift",
      templatePath: "data_implement_project.stencil"
    ),
    // Interface Project
    .file(
      path: "\(DataPath)/\(name)DataInterface/Project.swift",
      templatePath: "data_interface_project.stencil"
    ),
    // Tests Project
    .file(
      path: "\(DataPath)/\(name)DataTests/Project.swift",
      templatePath: "data_tests_project.stencil"
    ),
    // Repository Implementation
    .file(
      path: "\(DataPath)/\(name)Data/Sources/Repository/\(name)RepositoryImpl.swift",
      templatePath: "data_repository.stencil"
    ),
    // Repository Test
    .file(
      path: "\(DataPath)/\(name)DataTests/Sources/\(name)RepositoryTests.swift",
      templatePath: "data_tests.stencil"
    ),
    // Testing에 사용되는 Mock or Stub
    .file(
      path: "\(DataPath)/\(name)DataTesting/Sources/\(name)RepositoryMock.swift",
      templatePath: "data_testing_mock.stencil"
    ),
    // DTO
    .file(
      path: "\(DataPath)/\(name)DataInterface/Sources/DTO/\(name)DTO.swift",
      templatePath: "data_dto.stencil"
    ),
  ]
)
