//
//  MapViewAction.swift
//  MapFeature
//
//  Created by Jiyeon on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import BloomingClient
import Shared
import DesignKit

/// 지도 뷰에서 발생하는 액션들을 정의하는 열거형
public enum MapAction: Equatable {
  /// 현재 화면에 보이는 지도 영역의 좌표 범위를 요청
  /// - Note: 지도 이동 후 해당 영역의 꽃 명소 데이터를 가져올 때 사용
  case requestBounds
  
  /// 앱 시작 시 또는 최초 위치 설정 후 초기 지도 영역 요청
  /// - Note: 사용자 현재 위치로 이동 완료 후 자동으로 실행
  case requestInitialBounds
  
  /// 특정 꽃 명소의 개화 상태에 따라 마커 표시 상태를 업데이트
  /// - Parameter BloomStatus: 개화 상태 (피지않음, 피기시작, 만개, 져감)
  case updateMarkerStatus(BloomStatus)
  
  /// 지도에 그려진 경로선과 마커들을 모두 삭제
  /// - Note: 새로운 경로를 그리기 전이나 초기화할 때 사용
  case deletePath
  
  /// 사용자의 현재 위치로 지도 카메라를 이동
  /// - Parameter Coordinate: 이동할 좌표 (위도, 경도)
  case moveToUserLocation(Coordinate)
  
  /// 특정 명소까지의 경로를 지도에 그리기
  /// - Parameters:
  ///   - MapSpotEntity: 목적지 명소 정보
  ///   - [Coordinate]: 경로를 구성하는 좌표 배열
  case drawPath(MapSpotEntity, [Coordinate])

  /// 활성화된 마커를 변경 (선택된 상태로 표시)
  /// - Parameter MapSpotEntity: 활성화할 명소 정보
  case changeActiveMarker(MapSpotEntity)

  /// 특정 명소에 포커스 (경로 그리기 + 마커 활성화)
  /// - Parameter MapSpotEntity: 포커스할 명소 정보
  /// - Note: 검색 결과나 상세 정보에서 해당 위치를 강조할 때 사용
  case showFocus(MapSpotEntity)

  /// 현재 포커스된 요소들을 모두 제거
  /// - Note: 검색 결과나 상세 정보 해제 시 사용
  case clearFocus

  /// 지도에 표시할 명소 마커들을 업데이트
  /// - Parameter [Int: MapSpotEntity]: 명소 ID를 키로 하는 딕셔너리
  case updateMarkers([Int: MapSpotEntity])
}
