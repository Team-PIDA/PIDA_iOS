//
//  UserClient+Endpoint.swift
//  UserClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct UserEndPoint: Sendable {
  static func fetchUserInfo() -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization,
      method: .get,
      path: "/users/me"
    )
  }
  
  static func withDraw() -> Endpoint<WithdrawDTO> {
    return Endpoint(
      headers: .authorization,
      method: .delete,
      path: "/users"
    )
  }
  
  static func changeNickname(body: ChangeNicknameBody) -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization,
      method: .put,
      path: "/users/nickname",
      parameters: .body(body)
    )
  }

  static func updateFCMToken(body: UpdateFCMTokenBody) -> Endpoint<UpdateFCMTokenDTO> {
    return Endpoint(
      headers: .authorizationWithDeviceId,
      method: .put,
      path: "/users/fcm-token",
      parameters: .body(body)
    )
  }
}
