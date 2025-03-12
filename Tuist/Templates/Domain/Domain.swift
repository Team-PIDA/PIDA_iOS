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
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: .string(DateFormatter().string(from: Date())))

let domainTemplate = Template(
    description: "Domain 템플릿",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        // Domain Interface 프로젝트 생성
        .file(
            path: "Projects/Domain/\(name)Interface/Project.swift",
            templatePath: "domain_interface_project.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)Interface/\(name)UseCase.swift",
            templatePath: "domain_usecase.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)Testing/\(name)UseCaseTests.swift",
            templatePath: "domain_usecase_tests.stencil"
        ),
        // Domain Implement 프로젝트 생성
        .file(
            path: "Projects/Domain/\(name)Implement/Project.swift",
            templatePath: "domain_implement_project.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)Implement/\(name)UseCaseImpl.swift",
            templatePath: "domain_usecase_implement.stencil"
        ),
        // Data Interface 프로젝트 생성 (Domain과 함께 관리)
        .file(
            path: "Projects/Data/\(name)Interface/Project.swift",
            templatePath: "data_interface_project.stencil"
        ),
        .file(
            path: "Projects/Data/\(name)Interface/\(name)Repository.swift",
            templatePath: "data_repository.stencil"
        )
    ]
)
