//
//  LocationService.swift
//  Utility
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import CoreLocation
import Shared

/// 위치 권한 관련 서비스 구현
@MainActor
final class LocationService: NSObject, CLLocationManagerDelegate {
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private var continuation: CheckedContinuation<Coordinate?, Never>?
  
  // MARK: - Initialize
  
  override init() {
    super.init()
  }
  
  // MARK: - Location Method
  func requestUserLocation() async -> Coordinate? {
    return await withCheckedContinuation { continuation in
      guard self.continuation == nil else {
        finish(nil)
        return
      }
      self.continuation = continuation
      let status = locationManager.authorizationStatus
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        finish(nil)
      default:
        finish(nil)
      }
    }
  }
  
  func requestUserRegion() async -> Region? {
    guard let coordinate = await requestUserLocation() else { return nil }
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let geocoder = CLGeocoder()
    let placemarks = try? await geocoder.reverseGeocodeLocation(location)
    guard let area = placemarks?.first?.administrativeArea else { return nil }
    return Region(administrativeArea: area)
  }

  private func finish(_ value: Coordinate?) {
    continuation?.resume(returning: value)
    continuation = nil
  }
  
  // MARK: - Delegate
  
  nonisolated func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }
    
    let coord = Coordinate(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
    
    Task { @MainActor in
      locationManager.stopUpdatingLocation()
      finish(coord)
     }
  }
  
  nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    Task { @MainActor in
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      default:
        finish(nil)
      }
    }
    
  }
}
