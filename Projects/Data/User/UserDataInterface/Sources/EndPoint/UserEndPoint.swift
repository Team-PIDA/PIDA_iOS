//
//  UserEndPoint.swift
//  UserDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import UserDefault

public struct UserEndPoint: Sendable {
  static let baseURL = "https://api.pida.me/api/v1"
  
  public static func fetchUserInfo() -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .get,
      baseURL: baseURL,
      path: "/users/me"
    )
  }
  
  public static func withDraw() -> Endpoint<WithdrawDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .delete,
      baseURL: baseURL,
      path: "/users"
    )
  }
  
  public static func changeNickname(body: ChangeNicknameBody) -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .put,
      baseURL: baseURL,
      path: "/users/nickname",
      parameters: .body(body)
    )
  }
}
