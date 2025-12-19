//
//  ReissueTokenBody.swift
//  Networker
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct ReissueTokenBody: Encodable {
  public var refreshToken: String
  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }
}
