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

/// 파일 경로
fileprivate let FeaturePath: String = "Projects/Feature/\(name)"

let featureTemplate = Template(
  description: "SwiftUI + TCA 기반 Feature 모듈 템플릿",
  attributes: [name, author],
  items: [
    // Feature의 Project.swift 파일 생성
    .file(
      path: "\(FeaturePath)/Project.swift",
      templatePath: "feature_project.stencil"
    ),
    // Feature의 implement 파일 (TCA)
    .file(
      path: "\(FeaturePath)/\(name)Feature/Sources/\(name)Feature.swift",
      templatePath: "feature_implement.stencil"
    ),
    // Feature의 interface 파일
    .file(
      path: "\(FeaturePath)/\(name)FeatureInterface/Sources/\(name)Feature.swift",
      templatePath: "feature_interface.stencil"
    ),
    // Feature의 SwiftUI View 파일
    .file(
      path: "\(FeaturePath)/\(name)FeatureInterface/Sources/\(name)View.swift",
      templatePath: "feature_view.stencil"
    ),
    // Feature의 Unit Test 폴더 및 파일 생성
    .file(
      path: "\(FeaturePath)/\(name)FeatureTests/Sources/\(name)UnitTests.swift",
      templatePath: "feature_tests.stencil"
    ),
    // Feature의 Unit Test 데이터 관련 파일 생성
    .file(
      path: "\(FeaturePath)/\(name)FeatureTesting/Sources/\(name)UnitTestMock.swift",
      templatePath: "feature_testing_mock.stencil"
    ),
    // Feature의 Demo (예제) 파일 생성
      .file(
        path: "\(FeaturePath)/\(name)FeatureDemo/Sources/AppDelegate.swift",
        templatePath: "feature_demo_appdelegate.stencil"
      ),
    // Feature의 Resources 파일 생성
    .file(
      path: "\(FeaturePath)/\(name)FeatureDemo/Resources/Assets.xcassets/Contents.json",
      templatePath: "feature_resources_contents.stencil"
    ),
    .file(
      path: "\(FeaturePath)/\(name)FeatureDemo/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json",
      templatePath: "feature_resources_appicon.stencil"
    )
  ]
)
