//
//  UserClient+Live.swift
//  UserClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import APIClient

extension UserClient: DependencyKey {
  public static var liveValue: UserClient {
    @Dependency(\.apiClient) var apiClient
    
    return .init(
      changeNickname: { nickname in
        let body = ChangeNicknameBody(nickname: nickname)
        let endpoint = UserEndPoint.changeNickname(body: body)
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      fetchUserInfo: {
        let endpoint = UserEndPoint.fetchUserInfo()
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      withdrawUser: {
        let endpoint = UserEndPoint.withDraw()
        let result = try await apiClient.execute(endpoint).toEntity()
        return result
      },
      updateFCMToken: { fcmToken in
        let body = UpdateFCMTokenBody(fcmToken: fcmToken)
        let endpoint = UserEndPoint.updateFCMToken(body: body)
        _ = try await apiClient.execute(endpoint)
      }
    )
  }
}
