//
//  APIClient.swift
//  NetworkClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import ComposableArchitecture

@DependencyClient
public struct APIClient: Sendable {
  /// API 요청을 실행합니다.
  ///
  /// - Parameters:
  ///  - endpoint: 요청할 API 엔드포인트를 나타내는 `APIRequestable` 프로토콜을 준수하는 객체입니다.
  ///  - timeout: 요청의 타임아웃 시간을 초 단위로 지정합니다
  public var execute: @Sendable (
    _ endpoint: any APIRequestable
  ) async throws -> any (Decodable & Sendable)
  
  /// 파일 업로드를 수행합니다.
  ///
  /// - Parameters:
  ///  - url: 업로드할 파일의 대상 URL을 나타내는 문자열입니다
  ///  - data: 업로드할 파일의 데이터를 나타내는 `Data` 객체입니다.
  ///  - timeout: 업로드 요청의 타임아웃 시간을 초 단위로 지정
  public var upload: @Sendable (
    _ url: String,
    _ data: Data,
  ) async throws -> Void
  
  /// 이미지 다운로드를 수행합니다.
  ///
  /// - Parameters:
  ///   - url: 다운로드할 이미지의 URL을 나타내는 `String` 객체입니다.
  public var download: @Sendable (
    _ url: String
  ) async throws -> Data
}

// MARK: - DependencyValues Extension
public extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

