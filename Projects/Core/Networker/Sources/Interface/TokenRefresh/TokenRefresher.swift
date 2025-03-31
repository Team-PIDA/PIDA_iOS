//
//  TokenRefresher.swift
//  Networker
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public protocol TokenRefresher: Sendable {
  static func refreshToken() async throws -> String?
}
