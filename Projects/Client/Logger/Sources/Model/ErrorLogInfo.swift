//
//  ErrorLogInfo.swift
//  LoggerClient
//
//  Created by Claude
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation

public struct ErrorLogInfo: Sendable {
  public let error: Error
  public let path: String
  public let method: String?
  public let statusCode: Int?
  public let timestamp: String?
  public let url: String?
  public let parameters: String?
  public let headers: String
  
  public init(
    error: Error,
    path: String,
    method: String? = nil,
    statusCode: Int? = nil,
    timestamp: String? = nil,
    url: String? = nil,
    parameters: String? = nil,
    headers: String
  ) {
    self.error = error
    self.path = path
    self.method = method
    self.statusCode = statusCode
    self.timestamp = timestamp
    self.url = url
    self.parameters = parameters
    self.headers = headers
  }
  
  public func formatLogMessage() -> String {
    let errorMessage = formatErrorDescription(error)
    
    if let method = method, let statusCode = statusCode {
      var message = "🚨 [\(statusCode)] \(method) \(path)"
      if let timestamp = timestamp {
        message += "\n- TimeStamp: \(timestamp)"
      }
      if let url = url {
        message += "\n- URL: \(url)"
      }
      if let parameters = parameters {
        message += "\n- Parameters: \(parameters)"
      }
      message += "\n- Headers: \(headers)"
      message += "\n- Message: \(errorMessage)"
      return message
    } else {
      var message = "🚨 [Error] \(path)"
      if let url = url {
        message += "\n- URL: \(url)"
      }
      if let parameters = parameters {
        message += "\n- Parameters: \(parameters)"
      }
      message += "\n- Headers: \(headers)"
      message += "\n- Message: \(errorMessage)"
      return message
    }
  }
  
  private func formatErrorDescription(_ error: Error) -> String {
    return error.localizedDescription
  }
}