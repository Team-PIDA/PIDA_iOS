//
//  DetailMapViewRepresentable.swift
//  FlowerSpotDetailFeatureInterface
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import UIKit
import SwiftUI
import DesignKit
import NMapsMap
import Shared

@MainActor
struct DetailMapViewRepresentable: UIViewRepresentable {
  
  var location: Coordinate
  var pathMarkers: [Coordinate]
  var state: BloomStatus
  
  @Binding var isNeedDrawPath: Bool
  @Binding var isNeedDeletePath: Bool
  
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let view = NMFNaverMapView()
    
    view.showZoomControls = false
    view.showCompass = false
    view.showIndoorLevelPicker = false
    view.showLocationButton = false
    view.showScaleBar = false
    
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 13.5
    view.mapView.liteModeEnabled = true
    
    view.mapView.allowsZooming = false
    view.mapView.touchDelegate = nil
    
    view.mapView.allowsRotating = false
    view.mapView.allowsTilting = false
    view.mapView.isTiltGestureEnabled = false
    view.mapView.isIndoorMapEnabled = false
    view.mapView.locationOverlay.hidden = true
    view.mapView.mapType = .basic

    view.clipsToBounds = true
    view.mapView.symbolScale = 0.8
    
    return view
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    
    if isNeedDrawPath && context.coordinator.path == nil {
      presentMarker(uiView, location: location, context: context)
      drawPathLine(uiView, for: pathMarkers, context: context)
      moveCamera(uiView, to: location)
      Task { @MainActor in isNeedDrawPath = false }
    }
    
    if isNeedDeletePath {
      context.coordinator.deletePath()
      context.coordinator.deleteMarker()
      Task { @MainActor in isNeedDeletePath = false }
    }
    
    if context.coordinator.bloomStatus != state {
      context.coordinator.updateBloomingStatue(state: state)
    }
  }
  
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
}

fileprivate extension DetailMapViewRepresentable {
  /// 카메라 이동
  private func moveCamera(_ view: NMFNaverMapView, to point: Coordinate?) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
      cameraUpdate.animation = .none
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  /// 경로 그리기
  private func drawPathLine(
    _ view: NMFNaverMapView,
    for newPath: [Coordinate],
    context: Context
  ) {
    if !context.coordinator.pathMarkers.isEmpty {
      return
    }
    let lines = newPath.map {
      NMGLatLng(lat: $0.latitude, lng: $0.longitude)
    }
    
    // 범위 제한
    let bounds = calculateBounds(from: lines)
    view.mapView.extent = bounds
    
    let path = NMFPath()
    path.width = 6
    path.color = state.color
    path.outlineColor = state.color
    path.path = NMGLineString(points: lines)
    path.mapView = view.mapView
    
    context.coordinator.pathMarkers = newPath
    context.coordinator.path = path
    
    guard let firstPoint = lines.first,
          let lastPoint = lines.last else { return }
    
    let start = drawMarker(view,
                           to: firstPoint,
                           icon: state.circleImage,
                           anchor: CGPoint(x: 0.5, y: 0.5))
    let end = drawMarker(view,
                         to: lastPoint,
                         icon: state.circleImage,
                         anchor: CGPoint(x: 0.5, y: 0.5))
    context.coordinator.startMarker = start
    context.coordinator.endMarker = end
  }
  
  /// 마커 그리기
  private func presentMarker(
    _ view: NMFNaverMapView,
    location: Coordinate,
    context: Context
  ) {
    let point = NMGLatLng(lat: location.latitude, lng: location.longitude)
    let marker = drawMarker(view, to: point, icon: state.activeImage)
    if context.coordinator.activeMarker == nil {
      context.coordinator.activeMarker = marker
    }
  }
  
  /// 마커 기본 설정 메서드
  private func drawMarker(
    _ view: NMFNaverMapView,
    to point: NMGLatLng,
    icon: UIImage,
    anchor: CGPoint = CGPoint(x: 0.5, y: 1)
  ) -> NMFMarker{
    let marker = NMFMarker(position: point)
    let nmImage = NMFOverlayImage(image: icon)
    marker.isHideCollidedSymbols = true
    marker.iconImage = nmImage
    marker.mapView = view.mapView
    marker.anchor = anchor
    
    return marker
  }
  
  
  private func calculateShrunkenBounds(from points: [NMGLatLng], by delta: Double) -> NMGLatLngBounds? {
    guard let bounds = calculateBounds(from: points) else { return nil }
    
    return NMGLatLngBounds(
      southWest: NMGLatLng(
        lat: bounds.southWestLat + delta,
        lng: bounds.southWestLng + delta
      ),
      northEast: NMGLatLng(
        lat: bounds.northEastLat - delta,
        lng: bounds.northEastLng - delta
      )
    )
  }
  
  private func calculateBounds(from points: [NMGLatLng]) -> NMGLatLngBounds? {
    guard !points.isEmpty else { return nil }
    
    var minLat = points[0].lat
    var maxLat = points[0].lat
    var minLng = points[0].lng
    var maxLng = points[0].lng
    
    for point in points {
      minLat = min(minLat, point.lat)
      maxLat = max(maxLat, point.lat)
      minLng = min(minLng, point.lng)
      maxLng = max(maxLng, point.lng)
    }
    
    return NMGLatLngBounds(
      southWest: NMGLatLng(lat: minLat, lng: minLng),
      northEast: NMGLatLng(lat: maxLat, lng: maxLng)
    )
  }
  
}

// MARK: - Coordinator

extension DetailMapViewRepresentable {
  
  class Coordinator: NSObject {
    var parent: DetailMapViewRepresentable
    var location: Coordinate? = nil
    var pathMarkers: [Coordinate] = []
    
    var activeMarker: NMFMarker? = nil
    var path: NMFPath? = nil
    var startMarker: NMFMarker? = nil
    /// 경로선 끝 마커
    var endMarker: NMFMarker? = nil
    
    var bloomStatus: BloomStatus? = nil
    
    init(_ parent: DetailMapViewRepresentable) {
      self.parent = parent
    }
    
    func updateBloomingStatue(state: BloomStatus) {
      if let activeMarker = activeMarker,
          let path = path,
          let startMarker = startMarker,
          let endMarker = endMarker {
        activeMarker.iconImage = NMFOverlayImage(image: state.activeImage)
        path.color = state.color
        path.outlineColor = state.color
        startMarker.iconImage = NMFOverlayImage(image: state.circleImage)
        endMarker.iconImage = NMFOverlayImage(image: state.circleImage)
        bloomStatus = state
      }
      
    }
    
    /// 경로 비활성화 처리 메서드
    func deletePath() {
      if let path = path,
         let startMarker = startMarker,
         let endMarker = endMarker {
        path.mapView = nil
        startMarker.mapView = nil
        endMarker.mapView = nil
        self.path = nil
        self.startMarker = nil
        self.endMarker = nil
      }
    }
    
    /// 마커 비활성화 메서드
    func deleteMarker() {
      if let activeMarker = activeMarker {
        activeMarker.mapView = nil
        self.activeMarker = nil
      }
    }
  }
}
