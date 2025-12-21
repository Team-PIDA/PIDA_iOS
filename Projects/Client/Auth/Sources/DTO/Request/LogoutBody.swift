//
//  LogoutBody.swift
//  AuthDataInterface
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct LogoutBody: Encodable {
  let token: String
  public init(token: String?) {
    self.token = token ?? "NONE"
  }
}
