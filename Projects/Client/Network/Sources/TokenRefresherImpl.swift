//
//  TokenRefresherImpl.swift
//  Networker
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Shared

public struct DefaultTokenRefresher: TokenRefresher {
  
  public static func refreshToken() async throws -> String? {
    if let refreshToken: String = KeyChainWrapper.read(forKey: .refreshToken) {
      let refreshEndpoint = Endpoint<TokenRefreshDTO>(
        headers: .plain,
        method: .post,
        path: "/auth/reissue",
        parameters: .body(ReissueTokenBody(refreshToken: refreshToken)),
        isRefreshToken: true
      )
      do {
        let response = try await Networker().execute(with: refreshEndpoint)
        KeyChainWrapper.save(response.refreshToken, forKey: .refreshToken)
        UserDefaultsKeys.accessToken = response.accessToken
        return response.accessToken
      } catch {
        UserDefaultsKeys.isLoggedIn = false
        KeyChainWrapper.delete(forKey: .refreshToken)
        UserDefaultsKeys.accessToken = nil
        throw TokenError.expiredToken
      }
      
    }
    throw TokenError.invalidToken
  }
}
