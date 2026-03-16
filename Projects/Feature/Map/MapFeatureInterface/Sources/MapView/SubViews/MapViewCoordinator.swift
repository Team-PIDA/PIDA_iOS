//
//  MapViewCoordinator.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import DesignKit
import NMapsMap
import Shared

// MARK: - Delegate

extension MapViewRepresentable {
  
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    /// 부모 뷰
    var parent: MapViewRepresentable
    /// 마지막 카메라 이동 위치
    var lastCameraPoint: Coordinate? = nil
    /// 현재 표시되어있는 마커 배열
    var markers: [NMFMarker] = []
    /// 현재 선택 된 마커가 있는지 체크하기 위한 프로퍼티
    var selectedPin: MapSpotEntity?
    /// 현재 선택되어있는 NMFMarker
    var activeMarker: NMFMarker? = nil
    /// 현재 그려져있는 경로 데이터
    var paths: NMFPath?
    /// 경로선 시작 마커
    var startMarker: NMFMarker? = nil
    /// 경로선 끝 마커
    var endMarker: NMFMarker? = nil
    /// 초기 지도 범위 요청 여부
    var isInitialBounds: Bool = true
    
    /// 특정 위치의 데이터
    var focusData: MapSpotEntity? = nil
    /// 지도에 보여주기 위한 특정 위치 마커
    var focusMarker: NMFMarker? = nil
    
    /// 지도에 그려진 경로의 좌표 데이터
    var drawPathPoints: [Coordinate] = []
    /// 현재 표시된 명소 데이터 (마커 업데이트 감지용)
    var currentFlowerPositions: [Int: MapSpotEntity] = [:]
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
    // MARK: - Delegate
    
    /// 지도 탭 이벤트
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
      if let onMarkerTapped = parent.onMarkerTapped {
        onMarkerTapped(nil)
      }
      if let _ = focusMarker {
        deleteSearchResult()
      }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
      if reason == NMFMapChangedByGesture || reason == NMFMapChangedByControl {
        parent.cameraMoveEvent?()
        if !isInitialBounds, !parent.isCameraMove {
          parent.isCameraMove = true
        }
      }
    }
    
    
    func deleteSearchResult() {
      deletePath()
      if let searchMarker = focusMarker {
        searchMarker.mapView = nil
      }
      focusData = nil
      focusMarker = nil
      
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
      // 앱 처음 진입 시 카메라 이동 완료 후 지도 범위 값 가져오도록 처리
      if isInitialBounds, parent.shouldRequestInitialBounds {
        parent.mapActions.append(.requestInitialBounds)
      }
    }
    
    /// 지도에 올라와있는 마커 삭제
    func deleteAllMarkers() {
      if !markers.isEmpty {
        markers.forEach {
          $0.mapView = nil
        }
        self.markers.removeAll()
      }
    }
    
    /// 경로 비활성화 처리 메서드
    func deletePath() {
      if let paths = paths,
         let startMarker = startMarker,
         let endMarker = endMarker {
        paths.mapView = nil
        startMarker.mapView = nil
        endMarker.mapView = nil
        self.paths = nil
        self.startMarker = nil
        self.endMarker = nil
        self.drawPathPoints = []
      }
    
    }
    
    /// 마커 비활성화 메서드
    @MainActor
     func deleteMarker() {
      if let data = selectedPin,
         let activeMarker = activeMarker {
        let bloomingStatus = data.bloomStatus
        activeMarker.iconImage = bloomingStatus.inactiveMarker(type: data.type)
        self.activeMarker = nil
        self.selectedPin = nil
      }
    }
    
    /// 마커 탭 이벤트에 따른 데이터 상태 처리
    @MainActor
    func markerTapEvent(marker: NMFMarker, data: MapSpotEntity) {
      
      // 검색 결과가 있을 경우 기존 검색 기록 삭제
      if focusData != nil {
        deleteSearchResult()
      }
      deletePath()
      deleteMarker()
      selectedPin = data
      activeMarker = marker
      
    }
    
    /// 마커 개화 상태 값 업데이트
    @MainActor
    func updateMarker(state: BloomStatus) {
      if let activeMarker = activeMarker {
        guard selectedPin?.bloomStatus != state else { return }
        if let pin = selectedPin {
          selectedPin = MapSpotEntity(id: pin.id, pinPoint: pin.pinPoint, path: pin.path, type: pin.type, bloomStatus: state)
        }
        activeMarker.iconImage = state.activeMarker(type: selectedPin?.type ?? .flower)
        
      } else if let focusMarker = focusMarker {
        guard focusData?.bloomStatus != state else { return }
        focusMarker.iconImage = state.activeMarker(type: focusData?.type ?? .flower)
      }
      if let path = paths,
          let startMarker = startMarker,
          let endMarker = endMarker {
        path.color = state.color
        path.outlineColor = state.color
        startMarker.iconImage = state.pathPointMarker
        endMarker.iconImage = state.pathPointMarker
      }
    }
    
  }
}
