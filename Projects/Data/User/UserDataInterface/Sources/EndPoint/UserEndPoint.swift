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
  public static func fetchUserInfo() -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .get,
      path: "/users/me"
    )
  }
  
  public static func withDraw() -> Endpoint<WithdrawDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .delete,
      path: "/users"
    )
  }
  
  public static func changeNickname(body: ChangeNicknameBody) -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .put,
      path: "/users/nickname",
      parameters: .body(body)
    )
  }
}
