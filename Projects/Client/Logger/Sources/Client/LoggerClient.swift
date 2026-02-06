//
//  LoggerClient.swift
//  LoggerClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture

@DependencyClient
public struct LoggerClient: Sendable {
  public var execute: @Sendable () async throws -> Void
}

public extension DependencyValues {
  var loggerClient /*<- 카멜케이스 적용*/ : LoggerClient {
    get { self[LoggerClient.self] }
    set { self[LoggerClient.self] = newValue }
  }
}
