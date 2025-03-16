//
//  MapDelegate.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import MapDomainInterface

import NMapsMap

// MARK: - Delegate

extension MapViewRepresentable {
  
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    /// 부모 뷰
    var parent: MapViewRepresentable
    /// 마지막 카메라 이동 위치
    var lastCameraPoint: MapPoint? = nil
    /// 현재 표시되어있는 마커 배열
    var markers: [NMFMarker] = []
    /// 현재 선택 된 마커가 있는지 체크하기 위한 프로퍼티
    var selectedPin: FlowerPosition?
    /// 현재 선택되어있는 NMFMarker
    var activeMarker: NMFMarker? = nil
    /// 현재 그려져있는 경로 데이터
    var paths: NMFPath?
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
    /// 지도 탭 이벤트
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
      parent.markerTappedEvent.send(nil)
    }
    
  }
}
