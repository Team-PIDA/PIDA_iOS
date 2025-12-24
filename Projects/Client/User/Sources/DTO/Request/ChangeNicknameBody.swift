//
//  ChangeNicknameBody.swift
//  UserClient
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct ChangeNicknameBody: Encodable {
  let nickname: String
  public init(nickname: String) {
    self.nickname = nickname
  }
}
