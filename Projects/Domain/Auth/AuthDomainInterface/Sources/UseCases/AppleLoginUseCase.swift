//
//  AppleLoginUseCase.swift
//  AuthDomainInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol AppleLoginUseCase {
  func execute(token: String) async throws -> SocialLoginEntity
}
