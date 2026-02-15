//
//  RequestLogInfo.swift
//  APIClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct RequestLogInfo: Sendable, Loggable {
  let method: String
  let url: String
  let body: String?
  
  public init(
    request: URLRequest
  ) {
    self.method = request.httpMethod ?? "none"
    self.url = request.url?.absoluteString ?? "none"
    self.body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) }
  }
  
  public func logMessage() -> String {
    var message = "🚀 [\(method)] \(url)"
    
    if let body = body {
      message += "\n- Body: \(body)"
    }
    
    return message
  }
}