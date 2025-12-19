//
//  TokenRefreshDTO.swift
//  Networker
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

struct TokenRefreshDTO: Sendable, Decodable {
  var isTemporaryToken: Bool
  var accessToken: String
  var refreshToken: String
}
