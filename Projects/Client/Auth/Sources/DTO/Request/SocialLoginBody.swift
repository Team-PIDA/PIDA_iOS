//
//  SocialLoginBody.swift
//  AuthClient
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct SocialLoginBody: Encodable {
  let token: String
  public init(token: String) {
    self.token = token
  }
}
