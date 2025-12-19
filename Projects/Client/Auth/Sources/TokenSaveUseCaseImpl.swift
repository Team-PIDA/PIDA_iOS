//
//  TokenSaveUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import UserDefault
import KeyChain

public struct TokenSaveUseCaseImpl: TokenSaveUseCase {
  public init() {}
  
  public func execute(tokenInfo: SocialLoginEntity) async {
    UserDefault.isLoggedIn = !tokenInfo.isTempToken
    UserDefault.accessToken = tokenInfo.accessToKen
    KeyChainWrapper.save(tokenInfo.refreshToken, forKey: .refreshToken)
  }
}
