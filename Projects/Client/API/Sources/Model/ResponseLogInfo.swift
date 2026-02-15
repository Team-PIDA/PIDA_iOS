//
//  ResponseLogInfo.swift
//  APIClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct ResponseLogInfo: Sendable, Loggable {
  public let status: Int
  public let method: String
  public let path: String
  public let timestamp: String
  public let data: String
  
  public init(
    status: Int,
    method: String,
    path: String,
    timestamp: String,
    data: String
  ) {
    self.status = status
    self.method = method
    self.path = path
    self.timestamp = timestamp
    self.data = data
  }
  
  public func logMessage() -> String {
    return """
    ✅ [\(status)] \(method) \(path)
    - TimeStamp: \(timestamp)
    - Data: \(data)
    """
  }
}