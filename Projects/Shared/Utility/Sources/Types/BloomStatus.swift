//
//  BloomStatus.swift
//  Utility
//
//  Created by Jiyeon on 3/29/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum BloomStatus: String {
  case little = "LITTLE"
  case bloomed = "BLOOMED"
  case withered = "WITHERED"
  case notBloomed = "NOT_BLOOMED"
}

public extension BloomStatus {
  var text: String {
    switch self {
    case .little:
      "아직이에요"
    case .bloomed:
      "만개에요!"
    case .withered:
      "저물었어요.."
    case .notBloomed:
      "안폈어요"
    }
  }
}
