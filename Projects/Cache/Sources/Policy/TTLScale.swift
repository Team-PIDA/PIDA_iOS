//
//  TTLScale.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 캐시 항목의 유효 기간(Time To Live, TTL)을 정의하는 열거형
public enum TTLScale: Sendable {
  case custom(TimeInterval)
  case low
  case medium
  case high
  
  public var timeInterval: TimeInterval {
    switch self {
    case let .custom(interval): return interval
    case .low: return 5
    case .medium: return 60
    case .high: return 600
    }
  }
}
