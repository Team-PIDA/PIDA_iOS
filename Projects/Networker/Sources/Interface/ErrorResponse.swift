//
//  ErrorResponse.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Sendable {
  public let success: Bool
  public let status: Int
  public let data: ErrorData
  public let timestamp: String
}

public struct ErrorData: Decodable, Sendable {
  public let errorClassName: String
  public let message: String
}
