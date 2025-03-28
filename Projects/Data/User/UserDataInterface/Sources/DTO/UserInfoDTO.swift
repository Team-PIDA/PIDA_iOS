//
//  UserInfoDTO.swift
//  UserDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import UserDomainInterface
import Networker

public struct UserInfoDTO: DTO {
  public typealias Entity = UserInfoEntity
  let userId: Int
  let email: String
  let name: String
  let nickname: String
  
  public init(
    userId: Int,
    email: String,
    name: String,
    nickname: String
  ) {
    self.userId = userId
    self.email = email
    self.name = name
    self.nickname = nickname
  }
  
  public func toEntity() throws -> UserInfoEntity {
    return .init(userId: userId, nickname: name)
  }
}
