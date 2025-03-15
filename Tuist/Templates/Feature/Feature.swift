//
//  Feature.swift
//  Templates
//
//  Created by 조용인 on 3/11/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let currentDate: Template.Attribute = .optional("currentDate", default: .string(DateFormatter().string(from: Date())))

let featureTemplate = Template(
    description: "SwiftUI + TCA 기반 Feature 모듈 템플릿",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        // Feature의 Project.swift 파일 생성
        .file(
            path: "Projects/Features/\(name)/Project.swift",
            templatePath: "feature_project.stencil"
        ),
        // Feature의 Interface 폴더 및 파일 생성
        .file(
            path: "Projects/Features/\(name)/\(name)FeatureInterface/Sources/\(name)FeatureInterface.swift",
            templatePath: "feature_interface.stencil"
        ),
        // Feature의 Implement 폴더 및 파일 생성
        .file(
            path: "Projects/Features/\(name)/\(name)Feature/Sources/\(name)Feature.swift",
            templatePath: "feature_implement.stencil"
        ),
        // Feature의 Reducer implement 파일 (TCA)
        .file(
            path: "Projects/Features/\(name)/\(name)Feature/Sources/\(name)Reducer.swift",
            templatePath: "feature_reducer_implement.stencil"
        ),
        // Feature Reducer의 interface 파일
        .file(
          path: "Projects/Features/\(name)/\(name)FeatureInterface/Sources/\(name)Reducer.swift",
          templatePath: "feature_reducer_interface.stencil"
        ),
        // Feature의 SwiftUI View 파일
        .file(
            path: "Projects/Features/\(name)/\(name)FeatureInterface/Sources/\(name)View.swift",
            templatePath: "feature_view.stencil"
        ),
        // Feature의 Unit Test 폴더 및 파일 생성
        .file(
            path: "Projects/Features/\(name)/\(name)FeatureTesting/Sources/\(name)UnitTests.swift",
            templatePath: "feature_tests.stencil"
        ),
        // Feature의 Demo (예제) 파일 생성
        .file(
            path: "Projects/Features/\(name)/\(name)Demo/Sources/AppDelegate.swift",
            templatePath: "feature_demo_appdelegate.stencil"
        ),
        // Feature의 Resources 파일 생성
        .file(
            path: "Projects/Features/\(name)/\(name)Demo/Resources/Assets.xcassets",
            templatePath: "feature_resources.stencil"
        )
    ]
)
