//
//  UserRepositoryImpl.swift
//
//  User
//
//  Created by JiYeon
//

import Foundation
import UserDataInterface
import UserDomainInterface
import Networker

public struct UserRepositoryImpl: UserRepository {
  private let network: NetworkProtocol

  public init(network: NetworkProtocol) {
    self.network = network
  }

  public func fetchUserInfo() async throws -> UserInfoEntity {
    let endpoint = UserEndPoint.fetchUserInfo()
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
  
  public func withdraw() async throws {
    let endpoint = UserEndPoint.withDraw()
    return try await network.execute(with: endpoint, timeout: 60).toEntity()
  }
}
