//
//  Client.swift
//  APIManifests
//
//  Created by 조용인 on 12/23/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")

/// 파일 경로
fileprivate let ClientPath: String = "Projects/Client/\(name)"

let dataTemplate = Template(
  description: "Client 모듈 템플릿",
  attributes: [
    name,
    author
  ],
  items: [
    .file(
      path: "\(ClientPath)/Project.swift",
      templatePath: "client_project.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/Client/\(name)Client.swift",
      templatePath: "client_base.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/Client/\(name)Client+Endpoint.swift",
      templatePath: "client_endpoint.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/Client/\(name)Client+Live.swift",
      templatePath: "client_live.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/DTO/Request/request_dummy.swift",
      templatePath: "client_dummy.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/DTO/Response/response_dummy.swift",
      templatePath: "client_dummy.stencil"
    ),
    .file(
      path: "\(ClientPath)/Sources/Entity/entity_dummy.swift",
      templatePath: "client_dummy.stencil"
    ),
  ]
)
