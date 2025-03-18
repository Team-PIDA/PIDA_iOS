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
import MapDomainInterface

import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  /// 사용자의 현재 위치 정보
  ///
  /// - 초기 및 현위치 버튼 탭 시에만 값이 채워져 있음
  /// - 현 위치 이동 플래그 기능과 유사하게 동작
  @Binding var userLocation: MapPoint?
  /// 지도에 보여줄 데이터
  @Binding var flowerPositions: [Int: FlowerPosition]
  /// 마커 탭 시 경로를 보여주기 위한 프로퍼티
  @Binding var newPath: [MapPoint]
  /// 마커 탭 시 이벤트를 전달하기 위한 publisher
  var markerTappedEvent: PassthroughSubject<Int?, Never>
  /// 지도 초기 위치 설정 - 석촌호수 근처
  private let defaultPoint: MapPoint = .init(latitude: 37.50545, longitude: 127.10143)
  
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
    moveCamera(mapView, to: defaultPoint)
    return mapView
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    if let userLocation = userLocation {
      moveUserLocation(uiView, to: userLocation, context: context)
    }
    if context.coordinator.markers.isEmpty {
      presentMarkers(uiView, flowers: flowerPositions, context: context)
    }
    if let _ = context.coordinator.selectedPin {
      drawPathLine(uiView, for: newPath, context: context)
    } else {
      context.coordinator.deletePathMarkers()
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
}

// MARK: - MapEvent

extension MapViewRepresentable {
  
  /// 특정 위치로 이동하기 위한 메서드
  private func moveUserLocation(_ view: NMFNaverMapView, to userLocation: MapPoint, context: Context) {
    /// 카메라 위치의 변화가 있을 때만 설정
    let cameraPosition = view.mapView.cameraPosition.target
    let point = MapPoint(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    if point != context.coordinator.lastCameraPoint {
      view.mapView.positionMode = .normal
      moveCamera(view, to: userLocation)
      context.coordinator.lastCameraPoint = userLocation
    }
    self.userLocation = nil
  }
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, to point: MapPoint?) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      view.mapView.zoomLevel = 13
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  /// 지도 위에 마커를 표시하기 위한 메서드
  private func presentMarkers(_ view: NMFNaverMapView, flowers: [Int: FlowerPosition], context: Context) {
    for pin in flowers {
      let position = pin.value.currentPosition
      let point = NMGLatLng(lat: position.latitude, lng: position.longitude)
      let marker = drawMarker(view, to: point, icon: pin.value.state.inactiveImage)
      marker.tag = UInt(pin.key)
      marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
        if let marker = overlay as? NMFMarker {
          marker.iconImage = pin.value.state.activeImage
          markerTapEvent(to: marker, context: context)
          moveCamera(view, to: position)
        }
        return true
      }
      context.coordinator.markers.append(marker)
    }
  }
  
  /// 마커 탭 시 경로 데이터를 가져오기 위한 이벤트 처리 메서드
  private func markerTapEvent(to marker: NMFMarker, context: Context) {
    if marker == context.coordinator.activeMarker { return }
    context.coordinator.deletePathMarkers()
    let tag = Int(marker.tag)
    context.coordinator.selectedPin = flowerPositions[tag]
    context.coordinator.activeMarker = marker
    markerTappedEvent.send(tag)
  }
  
  /// 경로 선을 그리기 위한 메서드
  private func drawPathLine(_ view: NMFNaverMapView, for newPath: [MapPoint], context: Context) {
    guard !newPath.isEmpty, let data = context.coordinator.selectedPin else {
      context.coordinator.deletePathMarkers()
      return
    }
    
    let lines = newPath.map {
      NMGLatLng(lat: $0.latitude, lng: $0.longitude)
    }
    
    // 기존 경로와 동일하면 다시 그리지 않음
    if let existingPath = context.coordinator.paths?.path,
        existingPath.points as? [NMGLatLng] == lines { return }
    
    let flowerState = data.state
    // 새로운 경로 그리기
    let path = NMFPath()
    path.width = 6
    path.color = flowerState.color
    path.outlineColor = flowerState.color
    path.path = NMGLineString(points: lines)
    path.mapView = view.mapView
    context.coordinator.paths = path
    
    // 양 끝 원 마커 추가
    guard let firstPoint = lines.first, let lastPoint = lines.last else { return }
    let start = drawMarker(view, to: firstPoint, icon: flowerState.circleImage, anchor: CGPoint(x: 0.5, y: 0.5))
    let end = drawMarker(view, to: lastPoint, icon: flowerState.circleImage, anchor: CGPoint(x: 0.5, y: 0.5))
    context.coordinator.startMarker = start
    context.coordinator.endMarker = end
  }
  
  /// 마커 기본 설정 메서드
  private func drawMarker(
    _ view: NMFNaverMapView,
    to point: NMGLatLng,
    icon: NMFOverlayImage,
    anchor: CGPoint = CGPoint(x: 0.5, y: 1)
  ) -> NMFMarker{
    let marker = NMFMarker(position: point)
    marker.isHideCollidedSymbols = true
    marker.iconImage = icon
    marker.anchor = anchor
    marker.mapView = view.mapView
    return marker
  }
  
}
