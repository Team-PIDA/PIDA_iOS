//
//  LocationClient.swift
//  LocationClient
//
//  Created by Jiyeon
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture
import Shared

@DependencyClient
public struct LocationClient: Sendable {
  public var requestUserLocation: @Sendable () async throws -> Coordinate?
}

public extension DependencyValues {
  var locationClient : LocationClient {
    get { self[LocationClient.self] }
    set { self[LocationClient.self] = newValue }
  }
}
