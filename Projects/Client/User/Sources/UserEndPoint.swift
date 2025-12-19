//
//  UserEndPoint.swift
//  UserDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import Shared

public struct UserEndPoint: Sendable {
  public static func fetchUserInfo() -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken ?? ""),
      method: .get,
      path: "/users/me"
    )
  }
  
  public static func withDraw() -> Endpoint<WithdrawDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken ?? ""),
      method: .delete,
      path: "/users"
    )
  }
  
  public static func changeNickname(body: ChangeNicknameBody) -> Endpoint<UserInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken ?? ""),
      method: .put,
      path: "/users/nickname",
      parameters: .body(body)
    )
  }
}
