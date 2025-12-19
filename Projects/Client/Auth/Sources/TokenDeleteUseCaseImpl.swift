//
//  TokenDeleteUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import UserDefault
import KeyChain

public struct TokenDeleteUseCaseImpl: TokenDeleteUseCase {
  public init() {}
  
  public func execute() async {
    UserDefault.isLoggedIn = false
    UserDefault.accessToken = nil
    KeyChainWrapper.delete(forKey: .refreshToken)
    UserDefault.username = nil
  }
}
