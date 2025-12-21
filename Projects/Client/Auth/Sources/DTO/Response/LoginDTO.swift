//
//  LoginDTO.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import APIClient

struct LoginDTO: DTO {
  typealias Entity = SocialLoginEntity
  
  var isTemporaryToken: Bool
  var accessToken: String
  var refreshToken: String
}

extension LoginDTO {
  func toEntity() throws -> Entity {
    return .init(
      isTempToken: isTemporaryToken,
      accessToKen: accessToken,
      refreshToken: refreshToken
    )
  }
}
