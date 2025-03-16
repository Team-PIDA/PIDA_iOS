//
//  MapViewRepresentable.swift
//  MapFeature
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  
  private let locationManager = CLLocationManager()
  @Binding var position: MapPoint?
  
  // MARK: - UI
  
  private let mapView: NMFNaverMapView = {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 13
    return view
  }()
  
  // MARK: - UIViewRepresentable Method
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    mapView.mapView.isTiltGestureEnabled = false
    mapView.mapView.touchDelegate = context.coordinator
    mapView.mapView.addCameraDelegate(delegate: context.coordinator)
    return mapView
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    configMovePosition(uiView, context: context)
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  // MARK: - Delegate
  
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    /// 부모 뷰
    var parent: MapViewRepresentable
    /// 마지막 카메라 이동 위치
    var lastCameraPoint: MapPoint? = nil
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
  }
}

extension MapViewRepresentable {
  
  // MARK: - MapEvent
  
  /// 특정 위치로 이동하기 위한 메서드
  private func configMovePosition(_ view: NMFNaverMapView, context: Context) {
    /// 카메라 위치의 변화가 있을 때만 설정
    let cameraPosition = view.mapView.cameraPosition.target
    let point = MapPoint(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    if point != context.coordinator.lastCameraPoint {
      view.mapView.positionMode = .normal
      moveCamera(view, point: position)
      context.coordinator.lastCameraPoint = position
    }
  }
  
  private func moveCamera(_ view: NMFNaverMapView, point: MapPoint?) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      view.mapView.moveCamera(cameraUpdate)
      
    }
  }
}
