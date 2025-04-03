//
//  CoreLocation+.swift
//  Utility
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import CoreLocation

func distanceInKilometers(
  from: CLLocationCoordinate2D,
  to: CLLocationCoordinate2D
) -> Double {
  let start = CLLocation(latitude: from.latitude, longitude: from.longitude)
  let end = CLLocation(latitude: to.latitude, longitude: to.longitude)
  
  let distanceInMeters = start.distance(from: end) // 단위: 미터
  let distanceInKilometers = distanceInMeters / 1000.0
  
  return distanceInKilometers
}
