//
//  UserInfoEntity.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct UserInfoEntity: Sendable, Equatable {
  public var userId: Int
  public var nickname: String
  
  public init(userId: Int, nickname: String) {
    self.userId = userId
    self.nickname = nickname
  }
}
