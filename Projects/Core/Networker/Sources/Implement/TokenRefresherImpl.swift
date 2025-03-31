//
//  TokenRefresherImpl.swift
//  Networker
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import KeyChain
import UserDefault
import Utility

public struct DefaultTokenRefresher: TokenRefresher {
  static let baseURL = "https://api.pida.me/api/v1"
  
  public static func refreshToken() async throws -> String? {
    if let refreshToken: String = KeyChainWrapper.read(forKey: .refreshToken) {
      let refreshEndpoint = Endpoint<TokenRefreshDTO>(
        headers: .plain,
        method: .post,
        baseURL: baseURL,
        path: "/auth/reissue",
        parameters: .body(ReissueTokenBody(refreshToken: refreshToken)),
        isRefreshToken: true
      )
      do {
        let response = try await Networker().execute(with: refreshEndpoint)
        KeyChainWrapper.save(response.refreshToken, forKey: .refreshToken)
        UserDefault.accessToken = response.accessToken
        return response.accessToken
      } catch {
        UserDefault.isLoggedIn = false
        KeyChainWrapper.delete(forKey: .refreshToken)
        UserDefault.accessToken = nil
        throw TokenError.expiredToken
      }
      
    }
    throw TokenError.invalidToken
  }
}
