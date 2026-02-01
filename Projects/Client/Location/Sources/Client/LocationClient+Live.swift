//
//  LocationClient+Live.swift
//  LocationClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import ComposableArchitecture
import CoreLocation

extension LocationClient: DependencyKey {
  public static var liveValue: Self {
    return .init(
      requestUserLocation: {
        await LocationService().requestUserLocation()
      },
      checkAuthorizationStatus: {
        let status = CLLocationManager().authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
      }
    )
  }
}
