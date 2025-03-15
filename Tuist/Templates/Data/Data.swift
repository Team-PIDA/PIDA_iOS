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
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: .string(DateFormatter().string(from: Date())))

let dataTemplate = Template(
    description: "Data 모듈 템플릿",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        // Data Implement 프로젝트 생성
        .file(
            path: "Projects/Data/\(name)/\(name)Data/Project.swift",
            templatePath: "data_implement_project.stencil"
        ),
        .file(
            path: "Projects/Data/\(name)/\(name)Data/Sources/\(name)RepositoryImpl.swift",
            templatePath: "data_repository_implement.stencil"
        ),
        // Data Interface 프로젝트 생성
        .file(
            path: "Projects/Data/\(name)/\(name)DataInterface/Project.swift",
            templatePath: "data_interface_project.stencil"
        ),
        .file(
            path: "Projects/Data/\(name)/\(name)DataInterface/Sources/\(name)DTO.swift",
            templatePath: "data_dto.stencil"
        ),
        .file(
            path: "Projects/Data/\(name)/\(name)DataTesting/Sources/\(name)RepositoryTests.swift",
            templatePath: "data_tests.stencil"
        )
    ]
)
