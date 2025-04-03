//
//  FlowerSpotListEntity.swift
//  FlowerSpotDomainInterface
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import DesignKit

public struct FlowerSpotListEntity: Equatable, Sendable {
  public var itemList: [FlowerSpot]
  public init(itemList: [FlowerSpot]) {
    self.itemList = itemList
  }
}


public struct FlowerSpot: Equatable, Sendable {
  public var id: Int
  public var address: String
  public var recentlyVisitedCount: Int
  public var bloomingStatus: BloomStatus
  public var streetName: String
  public var district: String
  public var description: String
  public var path: [MapPoint]
  public var pinPoint: MapPoint
  public var region: String
  
  public init(
    id: Int,
    address: String? = nil,
    recentlyVisitedCount: Int,
    bloomingStatus: BloomStatus,
    streetName: String,
    district: String? = nil,
    description: String? = nil,
    path: [MapPoint],
    pinPoint: MapPoint,
    region: String
  ) {
    self.id = id
    self.address = address ?? "주소 정보 없음"
    self.recentlyVisitedCount = recentlyVisitedCount
    self.bloomingStatus = bloomingStatus
    self.streetName = streetName
    self.district = district ?? "구 정보 없음"
    self.description = description ?? "꽃 정보 없음"
    self.path = path
    self.pinPoint = pinPoint
    self.region = region
  }
}

public struct MapPoint: Equatable, Sendable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
