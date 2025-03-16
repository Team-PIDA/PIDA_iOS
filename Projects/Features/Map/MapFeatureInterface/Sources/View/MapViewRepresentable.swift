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
  
  private let locationManager = CLLocationManager()
  
  /// 사용자의 현재 위치 정보
  ///
  /// - 초기 및 현위치 버튼 탭 시에만 값이 채워져 있음
  /// - 현 위치 이동 플래그 기능과 유사하게 동작
  @Binding var userLocation: MapPoint?
  /// 지도에 보여줄 데이터
  @Binding var flowerPositions: [Int: FlowerPosition]
  /// 마커 탭 시 경로를 보여주기 위한 프로퍼티
  @Binding var selectedPath: [MapPoint]
  /// 마커 탭 시 이벤트를 전달하기 위한 publisher
  var markerTappedEvent: PassthroughSubject<Int?, Never>
  
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
    if let _ = userLocation {
      moveUserLocation(uiView, context: context)
    }
    if context.coordinator.markers.isEmpty {
      presentMarkers(uiView, context: context)
    }
    if let _ = context.coordinator.selectedPin {
      drawMultipartPath(uiView, context: context)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
}

// MARK: - MapEvent

extension MapViewRepresentable {
  
  /// 특정 위치로 이동하기 위한 메서드
  private func moveUserLocation(_ view: NMFNaverMapView, context: Context) {
    /// 카메라 위치의 변화가 있을 때만 설정
    let cameraPosition = view.mapView.cameraPosition.target
    let point = MapPoint(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    if point != context.coordinator.lastCameraPoint {
      view.mapView.positionMode = .normal
      moveCamera(view, point: userLocation)
      context.coordinator.lastCameraPoint = userLocation
      
    }
    userLocation = nil
  }
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, point: MapPoint?) {
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
  private func presentMarkers(_ view: NMFNaverMapView, context: Context) {
    for pin in flowerPositions {
      
      let position = pin.value.currentPosition
      let marker = NMFMarker()
      marker.position = NMGLatLng(
        lat: position.latitude,
        lng: position.longitude
      )
      marker.mapView = view.mapView
      marker.iconImage = .init(image: pin.value.state.inactiveImage)
      marker.tag = UInt(pin.key)
      marker.isHideCollidedSymbols = true
      marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
        if let marker = overlay as? NMFMarker {
          marker.iconImage = .init(image: pin.value.state.activeImage)
          markerTapEvent(marker: marker, context: context)
          moveCamera(view, point: position)
        }
        return true
      }
      context.coordinator.markers.append(marker)
    }
    
  }
  
  /// 마커 및 경로 비활성화 처리 메서드
  private func markerInactive(context: Context) {
    if let existingPath = context.coordinator.paths {
      existingPath.mapView = nil
      context.coordinator.paths = nil
      
    }
    if let data = context.coordinator.selectedPin,
        let activeMarker = context.coordinator.activeMarker {
      activeMarker.iconImage = .init(image: data.state.inactiveImage)
    }
  }
  
  /// 마커 탭 시 경로 데이터를 가져오기 위한 이벤트 처리 메서드
  private func markerTapEvent(marker: NMFMarker, context: Context) {
    markerInactive(context: context)
    let tag = Int(marker.tag)
    context.coordinator.selectedPin = flowerPositions[tag]
    context.coordinator.activeMarker = marker
    
    markerTappedEvent.send(tag)
  }
  
  /// 경로 선을 그리기 위한 메서드
  private func drawMultipartPath(_ view: NMFNaverMapView, context: Context) {
    
    if !selectedPath.isEmpty, let data = context.coordinator.selectedPin {
      let lines = selectedPath.map {
        NMGLatLng(lat: $0.latitude, lng: $0.longitude)
      }
      let path = NMFPath()
      path.color = data.state.color
      path.outlineColor = data.state.color
      path.path = NMGLineString(points: lines)
      path.mapView = view.mapView
      context.coordinator.paths = path
      
    } else if let _ = context.coordinator.paths {
      // 경로 데이터가 비어있지만 저장된 경로가 있을 경우 -> 선택 비활성화
      markerInactive(context: context)
    }
    
  }
}


