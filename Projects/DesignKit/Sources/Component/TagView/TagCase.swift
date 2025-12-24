//
//  TagCase.swift
//  DesignKit
//
//  Created by 조용인 on 4/9/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum TagCase: Hashable {
  case district(value: String)
  case recentVisitCount(value: String)
  case informant(value: String)
  
  var tagName: String {
    switch self {
    case let .district(value): return value
    case let .recentVisitCount(value): return value
    case let .informant(value): return "\(value) 제보"
    }
  }
}
