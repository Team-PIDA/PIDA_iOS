//
//  LoginDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import Networker

public struct LoginDTO: DTO {
  public typealias Entity = SocialLoginEntity
  
  public var isTemporaryToken: Bool
  public var accessToken: String
  public var refreshToken: String
  
  
}

extension LoginDTO {
  public func toEntity() throws -> SocialLoginEntity {
    return .init(
      isTempToken: isTemporaryToken,
      accessToKen: accessToken,
      refreshToken: refreshToken
    )
  }
}
