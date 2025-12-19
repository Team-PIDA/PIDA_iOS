//
//  TokenSaveUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import Shared

public struct TokenSaveUseCaseImpl: TokenSaveUseCase {
  public init() {}
  
  public func execute(tokenInfo: SocialLoginEntity) async {
    UserDefaultsKeys.isLoggedIn = !tokenInfo.isTempToken
    UserDefaultsKeys.accessToken = tokenInfo.accessToKen
    KeyChain.save(tokenInfo.refreshToken, forKey: .refreshToken)
  }
}
