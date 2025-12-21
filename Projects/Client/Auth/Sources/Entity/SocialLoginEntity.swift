//
//  SocialLoginEntity.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct SocialLoginEntity: Sendable, Equatable {
  
  public let isTempToken: Bool
  public let accessToKen: String
  public let refreshToken: String
  
  public init(
    isTempToken: Bool,
    accessToKen: String,
    refreshToken: String
  ) {
    self.isTempToken = isTempToken
    self.accessToKen = accessToKen
    self.refreshToken = refreshToken
  }
}
