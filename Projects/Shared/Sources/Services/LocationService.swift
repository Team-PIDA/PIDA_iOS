//
//  LocationService.swift
//  Utility
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import CoreLocation

/// 위치 권한 관련 서비스 구현
@MainActor
public class LocationService: NSObject, CLLocationManagerDelegate {
  
  public static let shared = LocationService()
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private var singleLocationContinuation: CheckedContinuation<Coordinate?, Never>?

  // MARK: - Initialize
  
  private override init() {
    super.init()
  }
  
  // MARK: - Location Method
  public func requestUserLocation() async -> Coordinate? {
    return await withCheckedContinuation { continuation in
      self.singleLocationContinuation = continuation
      let status = locationManager.authorizationStatus
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        singleLocationContinuation = nil
        continuation.resume(returning: nil)
      default:
        singleLocationContinuation = nil
        continuation.resume(returning: nil)
      }
    }
  }
  
    // MARK: - Delegate
    
    nonisolated public func locationManager(
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
        singleLocationContinuation?.resume(with: .success(coord))
        singleLocationContinuation = nil
      }

  }
  
  nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    
    Task { @MainActor in
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      case .notDetermined:
        break
      default:
        singleLocationContinuation?.resume(returning: nil)
        singleLocationContinuation = nil
      }
      
    }
  }
}
