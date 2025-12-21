//
//  AuthClient+Live.swift
//  AuthClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient
import Shared

extension AuthClient: DependencyKey {
  public static var liveValue: Self {
    @Dependency(\.apiClient) var apiClient
    
    return .init(
      appleLogin: { token in
        let endpoint = AuthEndpoint.appleLogin(body: .init(token: token))
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      signUp: { email, nickname in
        let endpoint = AuthEndpoint.signUp(body: .init(email: email, name: nickname))
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      logout: {
        let token = UserDefaultsKeys.accessToken
        let endpoint = AuthEndpoint.logout(body: .init(token: token))
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      deleteTokenInfo: {
        UserDefaultsKeys.isLoggedIn = false
        UserDefaultsKeys.accessToken = nil
        KeyChain.delete(forKey: .refreshToken)
        UserDefaultsKeys.username = nil
      },
      saveTokenInfo: { isTempToken, accessToken, refreshToken in
        UserDefaultsKeys.isLoggedIn = !isTempToken
        UserDefaultsKeys.accessToken = accessToken
        KeyChain.save(refreshToken, forKey: .refreshToken)
      }
    )
  }
}
