//
//  ChangeNicknameUseCase.swift
//  UserDomain
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UserDomainInterface

public struct ChangeNicknameUseCaseImpl: ChangeNicknameUseCase {
  private let repository: UserRepository
  
  public init(repository: UserRepository) {
    self.repository = repository
  }
  
  public func execute(nickname: String) async throws -> UserInfoEntity {
    return try await repository.changeNickname(nickname: nickname)
  }
}
