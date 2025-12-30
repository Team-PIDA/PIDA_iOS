//
//  LocationClient.swift
//  LocationClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture

@DependencyClient
public struct LocationClient: Sendable {
  public var execute: @Sendable () async throws -> Void
}

public extension DependencyValues {
  var LocationClient /*<- 카멜케이스 적용*/ : LocationClient {
    get { self[LocationClient.self] }
    set { self[LocationClient.self] = newValue }
  }
}
