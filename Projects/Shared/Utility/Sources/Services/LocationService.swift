//
//  LocationService.swift
//  Utility
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

/// 위치 권한 관련 서비스 구현
public final class LocationService: NSObject, CLLocationManagerDelegate {
  
  public static let shared = LocationService()
  public var userLocationEvent = PassthroughSubject<Void, Never>()
  public var userLostion: (Double, Double)? = nil
  
  private let locationManager = CLLocationManager()
  
  // MARK: - Initialize
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = .greatestFiniteMagnitude
  }
  
  // MARK: - Location Method
  
  public func requestUserLocation() async {
    let authorizationStatus = locationManager.authorizationStatus
    switch authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      await currentLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      // TODO: - 위치 권한 거부 시 토스트?
      break
    @unknown default:
      break
    }
  }
  
  /// 현재 위치 좌표 받아오기
  @MainActor
  private func currentLocation() {
    locationManager.startUpdatingLocation()
    let lat: Double? = locationManager.location?.coordinate.latitude
    let lng: Double? = locationManager.location?.coordinate.longitude
    if let lat = lat, let lng = lng {
      userLostion = (lat, lng)
      userLocationEvent.send(())
      locationManager.stopUpdatingLocation()
    } else {
      userLostion = nil
    }
  }
  
}
