//
//  BloomingClient.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

@DependencyClient
public struct BloomingClient: Sendable {
  public var getBloomingState: @Sendable (_ id: Int) async throws -> BloomStatusEntity
  public var updateBloomingState: @Sendable (_ id: Int, _ status: String) async throws -> UpdateBloomingStateEntity
  public var verifyBloomingToday: @Sendable (_ id: Int) async throws -> VerifyBloomingStateEntity
}

public extension DependencyValues {
  var bloomingClient: BloomingClient {
    get { self[BloomingClient.self] }
    set { self[BloomingClient.self] = newValue }
  }
}
