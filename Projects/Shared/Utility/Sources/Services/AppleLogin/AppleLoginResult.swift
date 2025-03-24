//
//  AppleLoginResult.swift
//  Utility
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct AppleLoginResult: Equatable {
  public let idToken: String
  public let fullName: String?
  public let email: String?
}
