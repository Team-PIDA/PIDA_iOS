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
  public static func appleLogin(body: SocialLoginBody) -> Endpoint<LoginDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/social-login/apple",
      parameters: .body(body)
    )
  }
  
  public static func signUp(body: SignUpBody) -> Endpoint<SignUpDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/social-signup",
      parameters: .body(body)
    )
  }
  
  public static func logout(body: LogoutBody) -> Endpoint<LogoutDTO> {
    return Endpoint(
      method: .post,
      path: "/auth/logout",
      parameters: .body(body)
    )
  }
  
}
