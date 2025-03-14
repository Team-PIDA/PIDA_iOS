//
//  BaseResponse.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct APIResponse<R>: Decodable & Sendable where R: Decodable & Sendable {
  let success: Bool
  let status: Int
  let timestamp: String
  let data: R?
  
  var isSuccess: Bool { success && (200..<300).contains(status) && data != nil }
}
