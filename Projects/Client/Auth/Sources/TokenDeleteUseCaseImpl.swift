//
//  TokenDeleteUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import AuthDomainInterface
import Shared

public struct TokenDeleteUseCaseImpl: TokenDeleteUseCase {
  public init() {}
  
  public func execute() async {
    UserDefaultsKeys.isLoggedIn = false
    UserDefaultsKeys.accessToken = nil
    KeyChainWrapper.delete(forKey: .refreshToken)
    UserDefaultsKeys.username = nil
  }
}
