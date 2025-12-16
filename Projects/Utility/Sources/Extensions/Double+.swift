//
//  Double+.swift
//  Utility
//
//  Created by Jiyeon on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import CoreLocation

public extension Double {
  /// 지정한 소수점 자리수까지 반올림
  ///
  /// - Parameters: places: 반올림 할 소수점 자리수
  func rounded(to places: Int) -> Double {
    let multiplier = pow(10.0, Double(places))
    return (self * multiplier).rounded() / multiplier
  }
  
  /// 두 좌표 간의 거리 계산 (단위: 킬로미터)
  ///
  /// - Parameters:
  ///  - from: 시작 좌표
  ///  - to: 도착 좌표
  static func distanceInKilometers(
    from: CLLocationCoordinate2D,
    to: CLLocationCoordinate2D
  ) -> Double {
    let start = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let end = CLLocation(latitude: to.latitude, longitude: to.longitude)
    
    let distanceInMeters = start.distance(from: end) // 단위: 미터
    let distanceInKilometers = distanceInMeters / 1000.0
    
    return distanceInKilometers
  }
}

