//
//  UserClient.swift
//  UserClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture

@DependencyClient
public struct UserClient: Sendable {
  public var changeNickname: @Sendable (String) async throws -> UserInfoEntity
  public var fetchUserInfo: @Sendable () async throws -> UserInfoEntity
  public var withdrawUser: @Sendable () async throws -> WithDrawEntity
}

public extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
