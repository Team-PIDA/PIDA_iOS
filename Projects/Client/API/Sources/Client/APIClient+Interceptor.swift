//
//  APIClient+Interceptor.swift
//  NetworkClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import Shared

extension APIClient {
  static func refreshToken() async throws -> String? {
    if let refreshToken: String = KeyChain.read(forKey: .refreshToken) {
      let refreshEndpoint = Endpoint<TokenRefreshDTO>(
        headers: .plain,
        method: .post,
        path: "/auth/reissue",
        parameters: .body(["refreshToken": refreshToken]),
        isRefreshToken: true
      )
      do {
        let response = try await Self.internalExecute(refreshEndpoint)
        KeyChain.save(response.refreshToken, forKey: .refreshToken)
        UserDefaultsKeys.accessToken = response.accessToken
        return response.accessToken
      } catch {
        UserDefaultsKeys.isLoggedIn = false
        KeyChain.delete(forKey: .refreshToken)
        UserDefaultsKeys.accessToken = nil
        throw TokenError.expiredToken
      }
    }
    throw TokenError.invalidToken
  }
}
