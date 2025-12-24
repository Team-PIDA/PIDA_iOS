//
//  AuthClient+Endpoint.swift
//  AuthClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import APIClient

extension AuthClient {
  struct AuthEndpoint: Sendable {
    static func appleLogin(body: SocialLoginBody) -> Endpoint<LoginDTO> {
      return Endpoint(
        method: .post,
        path: "/auth/social-login/apple",
        parameters: .body(body)
      )
    }
    
    static func signUp(body: SignUpBody) -> Endpoint<SignUpDTO> {
      return Endpoint(
        method: .post,
        path: "/auth/social-signup",
        parameters: .body(body)
      )
    }
    
    static func logout(body: LogoutBody) -> Endpoint<LogoutDTO> {
      return Endpoint(
        method: .post,
        path: "/auth/logout",
        parameters: .body(body)
      )
    }
  }
}
