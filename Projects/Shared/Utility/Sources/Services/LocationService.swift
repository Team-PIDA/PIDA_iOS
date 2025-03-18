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
  public private(set) var userLocation: (Double, Double)? = nil
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private var userLocationContinuation: AsyncStream<Void>.Continuation?
  public lazy var userLocationStream: AsyncStream<Void> = {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.userLocationContinuation = continuation
    }
  }()
  
  // MARK: - Initialize
  
  private override init() {
    super.init()
  }
  
  // MARK: - Location Method
  
  public func requestUserLocation() {
    let authorizationStatus = locationManager.authorizationStatus
    switch authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.startUpdatingLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      // TODO: - 위치 권한 거부 시 토스트?
      break
    @unknown default:
      break
    }
  }
  
  private func setUserLocation(lat: Double, lng: Double) {
    userLocation = (lat, lng)
    userLocationContinuation?.yield(())
    locationManager.stopUpdatingLocation()
  }
  
  // MARK: - Delegate
  
  nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let lat = location.coordinate.latitude
    let lng = location.coordinate.longitude
    Task {
      await setUserLocation(lat: lat, lng: lng)
    }
  }
  
  nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      Task {
        await locationManager.startUpdatingLocation()
      }
    }
  }
}
