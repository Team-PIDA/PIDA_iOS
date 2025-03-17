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
public actor LocationService: NSObject, CLLocationManagerDelegate {
  
  public static let shared = LocationService()
  public private(set) var userLocation: (Double, Double)? = nil
  
  private let locationManager = CLLocationManager()
  /// 위치 권한 팝업 나타날 때 선택할 때 까지 await 상태로 기다리기 위한 프로퍼티
  private var continuation: CheckedContinuation<Void, Never>?
  
  private var userLocationContinuation: AsyncStream<Void>.Continuation?
  public lazy var userLocationStream: AsyncStream<Void> = {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.userLocationContinuation = continuation
    }
  }()
  
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
      await updateCurrentLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
      await withCheckedContinuation { continuation in
        self.continuation = continuation
      }
      await updateCurrentLocation()
    case .denied, .restricted:
      // TODO: - 위치 권한 거부 시 토스트?
      break
    @unknown default:
      break
    }
  }
  
  private func updateCurrentLocation() async {
    locationManager.startUpdatingLocation()
    
    if let location = locationManager.location {
      let lat: Double? = location.coordinate.latitude
      let lng: Double? = location.coordinate.longitude
      if let lat = lat, let lng = lng {
        userLocation = (lat, lng)
        userLocationContinuation?.yield(())
      } else {
        userLocation = nil
      }
      locationManager.stopUpdatingLocation()
    }
  }
  
  nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      Task {
        await self.resumeContinuation()
      }
    }
  }
  
  private func resumeContinuation() {
    continuation?.resume()
    continuation = nil
  }
}
