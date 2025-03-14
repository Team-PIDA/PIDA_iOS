//
//  NetworkProtocol.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol NetworkProtocol {
  /// 네트워크 통신을 위한 execute 메서드
  func execute<E: APIRequestable>(with endpoint: E, timeout: TimeInterval) async throws -> E.Response where E.Response: Decodable & Sendable
  /// Task의 checkCancellation를 통해, 네트워크 통신 도중의 cancel을 체크할 수 있음
  func executeWithTask<E: APIRequestable>(with endpoint: E, timeout: TimeInterval) -> Task<E.Response, Error> where E.Response: Decodable & Sendable
}
