//
//  Endpoint.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Shared

struct EmptyResponse: Codable {}

public struct Endpoint<R>: APIRequestable where R: Decodable & Sendable {
  public typealias Response = R
  
  public let headers: APIHeaderType
  public let method: HTTPMethod
  public let baseURL: URL?
  public let path: String
  public let parameters: HTTPRequestParameter?
  public let isRefreshToken: Bool
  
  public init(
    headers: APIHeaderType = .plain,
    method: HTTPMethod,
    baseURL: String = Constant.base_url ?? "",
    path: String,
    parameters: HTTPRequestParameter? = nil,
    isRefreshToken: Bool = false
  ) {
    self.headers = headers
    self.method = method
    self.baseURL = URL(string:baseURL)
    self.path = path
    self.parameters = parameters
    self.isRefreshToken = isRefreshToken
  }
}
