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
            path: "Projects/Domain/\(name)DomainInterface/Project.swift",
            templatePath: "domain_interface_project.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)DomainInterface/\(name)UseCase.swift",
            templatePath: "domain_usecase.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)DomainInterface/\(name)Repository.swift",
            templatePath: "domain_repository_interface.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)DomainTesting/\(name)UseCaseTests.swift",
            templatePath: "domain_usecase_tests.stencil"
        ),
        // Domain Implement 프로젝트 생성
        .file(
            path: "Projects/Domain/\(name)Domain/Project.swift",
            templatePath: "domain_implement_project.stencil"
        ),
        .file(
            path: "Projects/Domain/\(name)Domain/\(name)UseCaseImpl.swift",
            templatePath: "domain_usecase_implement.stencil"
        )
    ]
)
