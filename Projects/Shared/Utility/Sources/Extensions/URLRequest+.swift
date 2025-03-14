//
//  URLRequest+.swift
//  Utility
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension URLRequest {
  func setMethod(_ method: String) -> URLRequest {
    var urlRequest = self
    urlRequest.httpMethod = method
    return urlRequest
  }
  
  func appendingHeaders(_ headers: [String: String]) -> URLRequest {
    var urlRequest = self
    headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
    return urlRequest
  }
  
  func setBody(_ body: Encodable?, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
    var urlRequest = self
    guard let body = body else { throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    guard let data = try? encoder.encode(body) else { throw NSError(domain: "CLNetworker", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    urlRequest.httpBody = data
    return urlRequest
  }
}
