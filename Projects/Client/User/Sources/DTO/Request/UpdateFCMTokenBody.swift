//
//  UpdateFCMTokenBody.swift
//  UserClient
//
//  Created by Claude on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation

public struct UpdateFCMTokenBody: Encodable, Sendable {
  let fcmToken: String

  public init(fcmToken: String) {
    self.fcmToken = fcmToken
  }
}
