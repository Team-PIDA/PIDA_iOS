//
//  FoundationError.swift
//  Utility
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum FoundationError: Error, LocalizedError, Sendable {
  
  case invalidBody
  case failedToEncode(Sendable)
  case failedToDecode(Sendable)
  case failedToCreateURLComponents
  case failedToCasting(from: Sendable, to: Sendable)
  case thisValueIsNil(Sendable)
  
  case taskCancelled
  case taskFailed
  
  public var errorDescription: String {
    switch self {
    case .invalidBody: return "[Body가 존재하지 않습니다.]"
    case let .failedToEncode(type): return "[\(type)을(를) 인코딩하는데 실패하였습니다.]"
    case let .failedToDecode(type): return "[\(type)을(를 )디코딩에 실패하였습니다.]"
    case .failedToCreateURLComponents: return "[URLComponent 생성에 실패하였습니다.]"
    case let .failedToCasting(from, to): return "[\(from)을(를) \(to)로 캐스팅 하는데 실패하였습니다.]"
    case let .thisValueIsNil(type): return "[\(type)은(는) nil입니다.]"
    
    case .taskCancelled: return "[Task가 취소 되었습니다.]"
    case .taskFailed: return "[Task가 실패 했습니다.]"
    }
  }
}
