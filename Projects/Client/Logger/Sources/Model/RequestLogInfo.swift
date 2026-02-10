//
//  RequestLogInfo.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation

public struct RequestLogInfo: Sendable, Loggable {
  public let method: String
  public let url: String
  public let body: String?
  
  public init(
    method: String,
    url: String,
    body: String? = nil
  ) {
    self.method = method
    self.url = url
    self.body = body
  }
  
  public func logMessage() -> String {
    var message = "🚀 [\(method)] \(url)"
    
    if let body = body {
      message += "\n- Body: \(body)"
    }
    
    return message
  }
}
