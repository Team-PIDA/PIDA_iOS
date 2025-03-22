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
import Core

public struct AuthRepositoryImpl: AuthRepository {
  private let networker: PIDANetworkProtocol

  public init(
    networker: PIDANetworkProtocol
  ) {
    self.networker = networker
  }

  public func fetchData() async throws -> Void { }
}
