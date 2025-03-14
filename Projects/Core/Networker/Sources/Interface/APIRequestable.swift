//
//  APIRequestable.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Utility

public typealias HTTPHeaders = [String: String]
public typealias HTTPParameters = [String: Any]

public enum HTTPRequestParameter {
  case query(_ query: Encodable?)
  case body(_ parameter: Encodable?)
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

public protocol APIRequestable {
  associatedtype Response: Decodable & Sendable
  
  var baseURL: URL? { get }
  var method: HTTPMethod { get }
  var headers: HTTPHeaders { get }
  var path: String { get }
  var parameters: HTTPRequestParameter? { get }
  
  func toURLRequest() throws -> URLRequest
}

public extension APIRequestable {
  func toURLRequest() throws -> URLRequest {
    let url = try configureURL()
    var urlRequest = URLRequest(url: url)
      .setMethod(self.method.rawValue)
      .appendingHeaders(self.headers)
    if let parameters = self.parameters {
      switch parameters {
      case let .body(body): urlRequest = try urlRequest.setBody(body)
      case .query: break
      }
    }
    return urlRequest
  }
  
  fileprivate func configureURL() throws -> URL {
    guard let baseURL = baseURL else { throw NSError(domain: "Encodable", code: 0, userInfo: nil) } // TODO: FoundationError로 변경
    var url = baseURL.appendingPathComponent(path)
    if let parameters = parameters {
      switch parameters {
      case let .query(queries): url = try url.appendingQueries(queries)
      default: break
      }
    }
    return url
  }
}
