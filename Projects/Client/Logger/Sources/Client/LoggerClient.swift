//
//  LoggerClient.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture
import OSLog

@DependencyClient
public struct LoggerClient: Sendable {
  public var log: @Sendable (_ message: String, _ level: LogLevel) -> Void
  public var logLoggable: @Sendable (Loggable, _ level: LogLevel) -> Void
}

public extension DependencyValues {
  var loggerClient: LoggerClient {
    get { self[LoggerClient.self] }
    set { self[LoggerClient.self] = newValue }
  }
}
