//
//  Double+.swift
//  Utility
//
//  Created by Jiyeon on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension Double {
  /// 지정한 소수점 자리수까지 반올림
  ///
  /// - Parameters: places: 반올림 할 소수점 자리수
  func rounded(to places: Int) -> Double {
    let multiplier = pow(10.0, Double(places))
    return (self * multiplier).rounded() / multiplier
  }
}
