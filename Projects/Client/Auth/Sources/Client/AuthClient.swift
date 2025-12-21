//
//  AuthClient.swift
//  AuthClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

@DependencyClient
public struct AuthClient: Sendable {
  public var appleLogin: @Sendable (String) async throws -> SocialLoginEntity
  public var signUp: @Sendable (String, String) async throws -> SignUpEntity
  public var logout: @Sendable () async throws -> LogoutEntity
  public var deleteTokenInfo: @Sendable () async throws -> Void
  public var saveTokenInfo: @Sendable (SocialLoginEntity) async throws -> Void
}

public extension DependencyValues {
  var authClient: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}
