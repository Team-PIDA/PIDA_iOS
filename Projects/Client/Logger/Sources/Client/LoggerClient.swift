//
//  LoggerClient.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture
import OSLog

public enum LogLevel: Sendable {
  case debug
  case info
  case notice
  case error
  case fault
}

@DependencyClient
public struct LoggerClient: Sendable {
  public var log: @Sendable (_ message: String, _ level: LogLevel) -> Void
  public var logError: @Sendable (ErrorLogInfo) -> Void
}

public extension DependencyValues {
  var loggerClient /*<- 카멜케이스 적용*/ : LoggerClient {
    get { self[LoggerClient.self] }
    set { self[LoggerClient.self] = newValue }
  }
}
