//
//  AuthRepositoryImpl.swift
//
//  Auth
//
//  Created by JiYeon
//

import Foundation
import AuthDataInterface
import AuthDomainInterface
import Networker

public struct AuthRepositoryImpl: AuthRepository {
  private let network: NetworkProtocol

  public init(network: NetworkProtocol) {
    self.network = network
  }

  public func requestAppleLogin(token: String) async throws -> SocialLoginEntity {
    let endpoint = AuthEndpoint.appleLogin(body: .init(token: token))
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
}
