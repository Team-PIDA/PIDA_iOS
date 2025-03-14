//
//  NetworkError.swift
//  Networker
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Sendable {
  
  case invalidStatusCode(Int)
  case timeout(TimeInterval)
  case serverError(message: String, code: Int)
  
  public var errorDescription: String {
    switch self {
    case let .serverError(message, code): return "[에러코드: \(code)] - \(message)"
    case let .invalidStatusCode(code): return "[잘못 된 StatusCode] - \(code)"
    case let .timeout(time): return "[네트워크 요청 시간이 초과되었습니다.] - \(time)Seconds"
    }
  }
}
