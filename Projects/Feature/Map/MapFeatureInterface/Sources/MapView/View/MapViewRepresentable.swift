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
import DesignKit

import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  /// 사용자의 현재 위치 정보
  ///
  /// - 초기 및 현위치 버튼 탭 시에만 값이 채워져 있음
  /// - 현 위치 이동 플래그 기능과 유사하게 동작
  @Binding var userLocation: MapPoint?
  /// 지도에 보여줄 데이터
  @Binding var flowerPositions: [Int: FlowerSpot]
  
  /// 마커 탭 시 경로를 보여주기 위한 프로퍼티
  @Binding var newPath: [MapPoint]
  
  /// 지도 범위 요청 프로퍼티
  @Binding var requestBounds: Bool
  
  /// 지도를 움직일 경우 현 위치 재검색 버튼 활성화 하기 위한 트리거
  @Binding var isCameraMove: Bool
  
  /// 지도에 특정 위치를 표시하기 위한 프로퍼티
  @Binding var focusData: FlowerSpot?
  
  /// 마커 삭제 트리거
  @Binding var isNeedDeleteMarker: Bool
  
  /// 마커 그리기 트리거
  @Binding var isNeedDrawMarker: Bool
  
  /// 활성화 된 마커 상태를 업데이트
  @Binding var updateMarkerStatus: BloomStatus?
  
  /// 마커 탭 시 id값을 전달하기 위한 클로저
  var onMarkerTapped: ((Int?) -> Void)? = nil
  /// 지도 범위 좌표 값을 전달하기 위한 클로저
  var mapBounds: (([MapPoint]) -> Void)? = nil
  
  /// 지도 초기 위치 설정 - 석촌호수 근처
  private let defaultPoint: MapPoint = .init(latitude: 37.50545, longitude: 127.10143)
  
  // MARK: - UIViewRepresentable Method
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 13
    view.mapView.minZoomLevel = 9
    view.mapView.maxZoomLevel = 18
    view.mapView.isIndoorMapEnabled = false
    view.showIndoorLevelPicker = false
    view.mapView.liteModeEnabled = false
    view.mapView.isTiltGestureEnabled = false
    view.mapView.touchDelegate = context.coordinator
    view.mapView.addCameraDelegate(delegate: context.coordinator)
    view.mapView.symbolScale = 0.8
    
    moveCamera(view, to: defaultPoint)
    return view
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    if let userLocation = userLocation {
      moveUserLocation(uiView, to: userLocation, context: context)
    }
    
    if context.coordinator.markers.isEmpty, !flowerPositions.isEmpty {
      presentMarkers(uiView, flowers: flowerPositions, context: context)
    }
    
    // 마커 탭 이벤트 시
    if let data = context.coordinator.selectedPin {
      if isNeedDrawMarker, newPath != context.coordinator.drawPathPoints {
        drawPathLine(uiView, data: data, for: newPath, context: context)
        
      } else if isNeedDeleteMarker { // 그려져있는 마커 및 경로 삭제
        context.coordinator.deletePath()
        context.coordinator.deleteMarker()
      }
    }
    
    // 현 위치 재검색 액션
    if requestBounds, !context.coordinator.isInitialBounds {
      currentVisibleBounds(on: uiView.mapView)
      deleteDrawMarker(context: context)
      requestBounds = false
    }
    
    // 특정 위치에 나타날 데이터가 있을 경우
    if let focusData = focusData, context.coordinator.focusData != focusData {
      drawPathLine(uiView, data: focusData, for: focusData.path, context: context)
      drawFocusMarker(uiView, result: focusData, context: context)
    } else if focusData == nil, context.coordinator.focusData != nil {
      context.coordinator.deleteSearchResult()
    }
    
    if let state = updateMarkerStatus {
      context.coordinator.updateMarker(state: state)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
}

// MARK: - Action

extension MapViewRepresentable {
  
  /// 특정 위치에 마커를 표시
  func drawFocusMarker(_ view: NMFNaverMapView, result: FlowerSpot, context: Context) {
    // 중복 그리기 방지
    if context.coordinator.focusData == result { return }
    if let marker = context.coordinator.focusMarker {
      marker.mapView = nil
    }
    isNeedDeleteMarker = false
    context.coordinator.focusData = result
    
    let coord = NMGLatLng(lat: result.pinPoint.latitude, lng: result.pinPoint.longitude)
    let marker = drawMarker(view, to: coord, icon: result.bloomingStatus.activeImage)
    marker.isHideCollidedMarkers = true
    marker.zIndex = 100
    context.coordinator.focusMarker = marker
  }
  
  /// 현재 지도에 보이는 좌표 범위를 반환하는 메서드
  func currentVisibleBounds(on mapView: NMFMapView) {
    let bounds = mapView.projection.latlngBounds(fromViewBounds: mapView.bounds)
    let northEast = MapPoint(
      latitude: bounds.northEastLat.rounded(to: 6),
      longitude: bounds.northEastLng.rounded(to: 6)
    )
    let southWest = MapPoint(
      latitude: bounds.southWestLat.rounded(to: 6),
      longitude: bounds.southWestLng.rounded(to: 6)
    )
    if let mapBounds = mapBounds {
      mapBounds([southWest, northEast])
    }
  }
  
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
  private func moveCamera(_ view: NMFNaverMapView, to point: MapPoint?, zoomLevel: Double = 13) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: zoomLevel)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  /// 마커 탭 시 경로 데이터를 가져오기 위한 이벤트 처리 메서드
  private func markerTapEvent(to marker: NMFMarker, id: Int, context: Context) {
    // 같은 마커를 탭 하면 무시
    if marker == context.coordinator.activeMarker { return }
    if let data = flowerPositions[id] {
      marker.iconImage = data.bloomingStatus.activeImage
      context.coordinator.markerTapEvent(marker: marker, data: data)
      
      if let onMarkerTapped = onMarkerTapped {
        onMarkerTapped(id)
      }
    }
    
  }
  
  /// 여러 마커의 중간지점 찾는 메서드
  private func averageCenter(of points: [MapPoint]) -> MapPoint? {
    guard !points.isEmpty else { return nil }

    let total = points.reduce((lat: 0.0, lon: 0.0)) { result, point in
      (result.lat + point.latitude, result.lon + point.longitude)
    }

    let count = Double(points.count)
    return MapPoint(
      latitude: total.lat / count,
      longitude: total.lon / count
    )
  }
}

// MARK: - Draw & Delete

extension MapViewRepresentable {
  /// 지도에 올라와있는 마커 삭제
  func deleteDrawMarker(context: Context) {
    if !context.coordinator.markers.isEmpty {
      flowerPositions.removeAll()
      context.coordinator.deleteAllMarkers()
    }
  }
  
  /// 경로 선을 그리기 위한 메서드
  private func drawPathLine(_ view: NMFNaverMapView, data: FlowerSpot, for newPath: [MapPoint], context: Context) {
    
    // 그릴 경로가 없으면 종료
    guard !newPath.isEmpty else { return }
    
    
    // 이미 그려진 경로가 있다면 지우기
    if context.coordinator.drawPathPoints.count > 0 {
      context.coordinator.deletePath()
      // 마커도 지워야 한다면 지우기
      if context.coordinator.selectedPin != data {
        context.coordinator.deleteMarker()
      }
    }
    
    let lines = newPath.map {
      NMGLatLng(lat: $0.latitude, lng: $0.longitude)
    }
    
    // 기존 경로와 동일하면 다시 그리지 않음
    if let existingPath = context.coordinator.paths?.path,
       existingPath.points as? [NMGLatLng] == lines {
      return
    }
    
    context.coordinator.drawPathPoints = newPath
    
    let flowerState = data.bloomingStatus
    
    // 새로운 경로 그리기
    let path = NMFPath()
    path.width = 6
    path.color = flowerState.color
    path.outlineColor = flowerState.color
    path.path = NMGLineString(points: lines)
    path.mapView = view.mapView
    
    context.coordinator.paths = path
    
    // 양 끝 원 마커 추가
    guard let firstPoint = lines.first,
            let lastPoint = lines.last else { return }
    
    let start = drawMarker(view,
                           to: firstPoint,
                           icon: flowerState.circleImage,
                           anchor: CGPoint(x: 0.5, y: 0.5))
    let end = drawMarker(view,
                         to: lastPoint,
                         icon: flowerState.circleImage,
                         anchor: CGPoint(x: 0.5, y: 0.5))
    
    context.coordinator.startMarker = start
    context.coordinator.endMarker = end
    isNeedDrawMarker = false
  }
  
  /// 지도 위에 비활성화 마커를 표시하기 위한 메서드
  private func presentMarkers(_ view: NMFNaverMapView, flowers: [Int: FlowerSpot], context: Context) {
    // 마커 중간지점으로 카메라 이동
    let mid = averageCenter(of: flowers.values.map { $0.pinPoint })
    moveCamera(view, to: mid, zoomLevel: view.mapView.cameraPosition.zoom)
    
    for pin in flowers {
      let position = pin.value.pinPoint
      let point = NMGLatLng(lat: position.latitude, lng: position.longitude)
      
      let marker = drawMarker(view,
                              to: point,
                              icon: pin.value.bloomingStatus.inactiveImage)
      marker.tag = UInt(pin.key)
      
      // 마커 탭 이벤트 헨들러
      marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
        if let marker = overlay as? NMFMarker {
          markerTapEvent(to: marker, id: pin.value.id, context: context)
          moveCamera(view, to: position, zoomLevel: 14)
        }
        return true
      }
      
      context.coordinator.markers.append(marker)
      
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
    marker.isHideCollidedSymbols = true
    marker.iconImage = NMFOverlayImage(image: icon)
    marker.anchor = anchor
    marker.mapView = view.mapView
    
    return marker
  }
  
}
