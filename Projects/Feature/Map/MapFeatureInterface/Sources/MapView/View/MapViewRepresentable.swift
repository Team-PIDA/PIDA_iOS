//
//  MapViewRepresentable.swift
//  MapFeature
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit
import NMapsMap
import FlowerSpotClient
import BloomingClient
import Shared

public enum MapAction: Equatable {
  case requestBounds
  case requestInitialBounds
  case updateMarkerStatus(BloomStatus)
  case deletePath
  case moveToUserLocation(Coordinate)
}

struct MapViewRepresentable: UIViewRepresentable {
  /// 지도에 보여줄 데이터
  @Binding var flowerPositions: [Int: FlowerSpotEntity]
  
  /// 마커 탭 시 경로를 보여주기 위한 프로퍼티
  @Binding var newPath: [Coordinate]
  
  /// 지도를 움직일 경우 현 위치 재검색 버튼 활성화 하기 위한 트리거
  @Binding var isCameraMove: Bool
  
  /// 지도에 특정 위치를 표시하기 위한 프로퍼티
  @Binding var focusData: FlowerSpotEntity?
  
  /// 마커 그리기 트리거
  @Binding var isNeedDrawMarker: Bool
  
  /// 바텀시트 표시 여부 (카메라 중앙 위치 조정용)
  @Binding var hasBottomSheet: Bool
  
  /// 지도 액션 명령
  @Binding var mapAction: MapAction?
  
  /// 초기 bounds 요청 여부 (현재 위치 이동 완료 후 자동 실행용)
  @Binding var shouldRequestInitialBounds: Bool
  
  /// 마커 탭 시 id값을 전달하기 위한 클로저
  var onMarkerTapped: ((Int?) -> Void)? = nil
  /// 지도 범위 좌표 값을 전달하기 위한 클로저
  var mapBounds: (([Coordinate]) -> Void)? = nil
  
  var cameraMoveEvent: (() -> Void)? = nil
  
  /// 지도 초기 위치 설정 - 석촌호수 근처
  private let defaultPoint: Coordinate = .init(latitude: 37.50545, longitude: 127.10143)
  
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
    // 마커 데이터가 변경되었을 때 마커 업데이트
    if context.coordinator.currentFlowerPositions != flowerPositions {
      // 마커 ID 세트가 변경된 경우에만 카메라 이동 (데이터만 갱신된 경우 스킵)
      let shouldMoveCamera = Set(context.coordinator.currentFlowerPositions.keys) != Set(flowerPositions.keys)

      // 기존 마커 삭제
      if !context.coordinator.markers.isEmpty {
        context.coordinator.deleteAllMarkers()
      }

      if !flowerPositions.isEmpty {
        // 새로운 마커 표시
        presentMarkers(uiView, flowers: flowerPositions, context: context, shouldMoveCamera: shouldMoveCamera)
        context.coordinator.currentFlowerPositions = flowerPositions
      }
    }
    
    // 마커 탭 이벤트 시
    if let data = context.coordinator.selectedPin {
      if isNeedDrawMarker, newPath != context.coordinator.drawPathPoints {
        drawPathLine(uiView, data: data, for: newPath, context: context)
      }
    }
    
    // 특정 위치에 나타날 데이터가 있을 경우
    if let focusData = focusData, context.coordinator.focusData != focusData {
      drawPathLine(uiView, data: focusData, for: focusData.path, context: context)
      drawFocusMarker(uiView, result: focusData, context: context)
    } else if focusData == nil, context.coordinator.focusData != nil {
      context.coordinator.deleteSearchResult()
    }
    
    // 액션 기반 명령 처리
    if let action = mapAction {
      executeAction(action, on: uiView, context: context)
      mapAction = nil
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  /// 액션 기반 명령 실행
  private func executeAction(_ action: MapAction, on uiView: NMFNaverMapView, context: Context) {
    print(action)
    switch action {
    case .requestBounds:
      if !context.coordinator.isInitialBounds {
        currentVisibleBounds(on: uiView.mapView)
        deleteDrawMarker(context: context)
      }
      
    case .requestInitialBounds:
      currentVisibleBounds(on: uiView.mapView)
      context.coordinator.isInitialBounds = false
      shouldRequestInitialBounds = false
      
    case .updateMarkerStatus(let state):
      context.coordinator.updateMarker(state: state)
      
    case .deletePath:
      context.coordinator.deletePath()
      context.coordinator.deleteMarker()
      
    case .moveToUserLocation(let location):
      moveUserLocation(uiView, to: location, context: context)
    }
  }
  
}

// MARK: - Action

extension MapViewRepresentable {
  
  /// 특정 위치에 마커를 표시
  func drawFocusMarker(_ view: NMFNaverMapView, result: FlowerSpotEntity, context: Context) {
    // 중복 그리기 방지
    if context.coordinator.focusData == result { return }
    if let marker = context.coordinator.focusMarker {
      marker.mapView = nil
    }
    context.coordinator.focusData = result
    
    let state = BloomStatus(rawValue: result.bloomingStatus)
    let coord = NMGLatLng(lat: result.pinPoint.latitude, lng: result.pinPoint.longitude)
    let marker = drawMarker(view, to: coord, icon: state?.activeImage)
    marker.isHideCollidedMarkers = true
    marker.zIndex = 100
    context.coordinator.focusMarker = marker
  }
  
  /// 현재 지도에 보이는 좌표 범위를 반환하는 메서드
  func currentVisibleBounds(on mapView: NMFMapView) {
    let bounds = mapView.projection.latlngBounds(fromViewBounds: mapView.bounds)
    let northEast = Coordinate(
      latitude: bounds.northEastLat.rounded(to: 6),
      longitude: bounds.northEastLng.rounded(to: 6)
    )
    let southWest = Coordinate(
      latitude: bounds.southWestLat.rounded(to: 6),
      longitude: bounds.southWestLng.rounded(to: 6)
    )
    if let mapBounds = mapBounds {
      mapBounds([southWest, northEast])
    }
  }
  
  /// 특정 위치로 이동하기 위한 메서드
  private func moveUserLocation(_ view: NMFNaverMapView, to userLocation: Coordinate, context: Context) {
    /// 카메라 위치의 변화가 있을 때만 설정
    let cameraPosition = view.mapView.cameraPosition.target
    let point = Coordinate(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    
    if point != context.coordinator.lastCameraPoint {
      view.mapView.positionMode = .normal
      moveCamera(view, to: userLocation)
      context.coordinator.lastCameraPoint = userLocation
    }
  }
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, to point: Coordinate?, zoomLevel: Double = 13) {
    if let point = point {
      var adjustedPoint = point
      
      // 바텀시트가 있을 때 중앙 위치 조정
      if hasBottomSheet {
        adjustedPoint = adjustCenterForBottomSheet(originalPoint: point, mapView: view.mapView)
      }
      
      let coord = NMGLatLng(lat: adjustedPoint.latitude, lng: adjustedPoint.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: zoomLevel)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  /// 바텀시트를 고려한 중앙 위치 조정
  private func adjustCenterForBottomSheet(originalPoint: Coordinate, mapView: NMFMapView) -> Coordinate {
    let screenHeight = UIScreen.main.bounds.height
    let bottomSheetHeight = BottomSheetDetent.medium.visibleHeight(minHeight: 0.0, screenHeight: screenHeight) 
    let searchBarHeight: CGFloat = 60 // 대략적인 SearchBar 높이
    
    // 화면 중앙에서 위로 올릴 픽셀 오프셋
    let offsetFromCenter = (bottomSheetHeight / 2) - (searchBarHeight / 2)
    
    // 위도 오프셋 계산 (대략 1도 ≈ 111km, 픽셀당 변환)
    let projection = mapView.projection
    
    let originalLatLng = NMGLatLng(lat: originalPoint.latitude, lng: originalPoint.longitude)
    let centerScreenPoint = projection.point(from: originalLatLng)
    let adjustedScreenPoint = CGPoint(x: centerScreenPoint.x, y: centerScreenPoint.y + offsetFromCenter)
    let adjustedLatLng = projection.latlng(from: adjustedScreenPoint)
    
    return Coordinate(latitude: adjustedLatLng.lat, longitude: adjustedLatLng.lng)
  }
  
  /// 마커 탭 시 경로 데이터를 가져오기 위한 이벤트 처리 메서드
  private func markerTapEvent(to marker: NMFMarker, id: Int, context: Context) {
    // 같은 마커를 탭 하면 무시
    if marker == context.coordinator.activeMarker { return }
    if let data = flowerPositions[id],
       let state = BloomStatus(rawValue: data.bloomingStatus){
      marker.iconImage = NMFOverlayImage(image: state.activeImage)
      context.coordinator.markerTapEvent(marker: marker, data: data)
      
      if let onMarkerTapped = onMarkerTapped {
        onMarkerTapped(id)
      }
    }
    
  }
  
  /// 여러 마커의 중간지점 찾는 메서드
  private func averageCenter(of points: [Coordinate]) -> Coordinate? {
    guard !points.isEmpty else { return nil }

    let total = points.reduce((lat: 0.0, lon: 0.0)) { result, point in
      (result.lat + point.latitude, result.lon + point.longitude)
    }

    let count = Double(points.count)
    return Coordinate(
      latitude: total.lat / count,
      longitude: total.lon / count
    )
  }
  
  /// 경로의 모든 포인트가 보이도록 카메라 조정
  private func fitCameraToPath(_ view: NMFNaverMapView, path: [Coordinate]) {
    guard !path.isEmpty else { return }
    
    let latitudes = path.map { $0.latitude }
    let longitudes = path.map { $0.longitude }
    
    let minLat = latitudes.min() ?? 0
    let maxLat = latitudes.max() ?? 0
    let minLng = longitudes.min() ?? 0
    let maxLng = longitudes.max() ?? 0
    
    let bounds = NMGLatLngBounds(
      southWestLat: minLat,
      southWestLng: minLng,
      northEastLat: maxLat,
      northEastLng: maxLng
    )
    
    let cameraUpdate = NMFCameraUpdate(
      fit: bounds,
      paddingInsets: UIEdgeInsets(top: 200, left: 80, bottom: 250, right: 80)
    )
    cameraUpdate.animation = .easeOut
    cameraUpdate.animationDuration = 1
    
    view.mapView.moveCamera(cameraUpdate)
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
  private func drawPathLine(
    _ view: NMFNaverMapView,
    data: FlowerSpotEntity,
    for newPath: [Coordinate],
    context: Context
  ) {
    
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
    
    let flowerState = BloomStatus(rawValue: data.bloomingStatus) ?? .notBloomed
    // 새로운 경로 그리기
    let path = NMFPath()
    path.width = 6
    path.color = flowerState.color
    path.outlineColor = flowerState.color
    path.path = NMGLineString(points: lines)
    path.mapView = view.mapView
    path.globalZIndex = 1
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
    start.globalZIndex = 2
    end.globalZIndex = 2
    context.coordinator.startMarker = start
    context.coordinator.endMarker = end
    
    // 모든 경로 포인트가 보이도록 카메라 조정
    fitCameraToPath(view, path: newPath)
  }
  
  /// 지도 위에 비활성화 마커를 표시하기 위한 메서드
  private func presentMarkers(
    _ view: NMFNaverMapView,
    flowers: [Int: FlowerSpotEntity],
    context: Context,
    shouldMoveCamera: Bool = true
  ) {
    // 마커 중간지점으로 카메라 이동 (마커 ID 비교 확인 -> 현재 보이는 마커들)
    if shouldMoveCamera {
      let mid = averageCenter(of: flowers.values.map { $0.pinPoint })
      moveCamera(view, to: mid, zoomLevel: view.mapView.cameraPosition.zoom)
    }
    
    for pin in flowers {
      let position = pin.value.pinPoint
      let point = NMGLatLng(lat: position.latitude, lng: position.longitude)
      let flowerState = BloomStatus(rawValue: pin.value.bloomingStatus) ?? .notBloomed
      let marker = drawMarker(
        view,
        to: point,
        icon: flowerState.inactiveImage
      )
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
    icon: UIImage?,
    anchor: CGPoint = CGPoint(x: 0.5, y: 1)
  ) -> NMFMarker{
    let marker = NMFMarker(position: point)
    marker.isHideCollidedSymbols = true
    if let icon = icon { marker.iconImage = NMFOverlayImage(image: icon) }
    // TODO: 혹시 모르는 디폴트 이미지
    marker.anchor = anchor
    marker.mapView = view.mapView
    return marker
  }
  
}
