//
//  AuthEndpoint.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

public struct AuthEndpoint: Sendable {
  static let baseURL = "https://api.pida.me/api/v1"
  
  public static func appleLogin(body: SocialLoginBody) -> Endpoint<LoginDTO> {
    return Endpoint(
      method: .post,
      baseURL: baseURL,
      path: "/auth/social-login/apple",
      parameters: .body(body)
    )
  }
  
  public static func signUp(body: SignUpBody) -> Endpoint<SignUpDTO> {
    return Endpoint(
      method: .post,
      baseURL: baseURL,
      path: "/auth/social-signup",
      parameters: .body(body)
    )
  }
  
}
