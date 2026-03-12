//
//  MapSpotEntity.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/11/26.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import BloomingClient
import Shared
import DesignKit

/// 지도 렌더링에 필요한 최소 데이터를 담는 추상화 모델
public struct MapSpotEntity: Equatable, Sendable {
  public let id: Int
  public let pinPoint: Coordinate
  public let path: [Coordinate]
  public let type: MapSpotType
  public let bloomStatus: BloomStatus

  public init(
    id: Int,
    pinPoint: Coordinate,
    path: [Coordinate],
    type: MapSpotType,
    bloomStatus: BloomStatus
  ) {
    self.id = id
    self.pinPoint = pinPoint
    self.path = path
    self.type = type
    self.bloomStatus = bloomStatus
  }
}

public enum MapSpotType: Equatable, Sendable {
  case flowerPath
  case festival
  case cafe
}
