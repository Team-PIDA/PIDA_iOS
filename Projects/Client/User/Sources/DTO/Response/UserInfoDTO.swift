//
//  UserInfoDTO.swift
//  UserDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct UserInfoDTO: DTO {
  typealias Entity = UserInfoEntity
  
  let userId: Int
  let email: String
  let name: String
  let nickname: String
  
  init(
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
}

extension UserInfoDTO {
  func toEntity() throws -> Entity {
    return .init(
      userId: userId,
      nickname: nickname
    )
  }
}
