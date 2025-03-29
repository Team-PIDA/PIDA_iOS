//
//  AuthRepository.swift
//  AuthDomain
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol AuthRepository {
  func requestAppleLogin(token: String) async throws -> SocialLoginEntity
  func signUp(email: String, nickname: String) async throws -> SignUpEntity
  func logout(token: String) async throws
}
