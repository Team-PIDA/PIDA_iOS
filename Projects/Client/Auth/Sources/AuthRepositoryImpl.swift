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
  
  public func signUp(email: String, nickname: String) async throws -> SignUpEntity {
    let endpoint = AuthEndpoint.signUp(body: .init(email: email, name: nickname))
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
  
  public func logout(token: String) async throws {
    let endpoint = AuthEndpoint.logout(body: .init(token: token))
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
}
