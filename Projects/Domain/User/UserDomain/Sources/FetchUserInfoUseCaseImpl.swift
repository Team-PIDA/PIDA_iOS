//
//  FetchUserInfoUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UserDomainInterface

public struct FetchUserInfoUseCaseImpl: FetchUserInfoUseCase {
  private let repository: UserRepository
  
  public init(reporsitory: UserRepository) {
    self.repository = reporsitory
  }
  
  public func execute() async throws -> UserInfoEntity {
    return try await repository.fetchUserInfo()
  }
}
