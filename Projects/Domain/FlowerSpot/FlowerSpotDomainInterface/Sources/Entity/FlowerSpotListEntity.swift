//
//  FlowerSpotListEntity.swift
//  FlowerSpotDomainInterface
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct FlowerSpotListEntity: Equatable, Sendable {
  public var itemList: [FlowerSpot]
  public init(itemList: [FlowerSpot]) {
    self.itemList = itemList
  }
}


public struct FlowerSpot: Equatable, Sendable {
  public var id: Int
  public var address: String?
  public var recentlyVisitedCount: Int
  public var bloomingStatus: FlowerStatus
  public var streetName: String
  public var district: String?
  public var description: String?
  public var path: [MapPoint]
  public var pinPoint: MapPoint
  public var region: String
  
  public init(id: Int, address: String? = nil, recentlyVisitedCount: Int, bloomingStatus: FlowerStatus, streetName: String, district: String? = nil, description: String? = nil, path: [MapPoint], pinPoint: MapPoint, region: String) {
    self.id = id
    self.address = address
    self.recentlyVisitedCount = recentlyVisitedCount
    self.bloomingStatus = bloomingStatus
    self.streetName = streetName
    self.district = district
    self.description = description
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

public enum FlowerStatus: String, Sendable {
  case gone = "WITHERED"
  case many = "BLOOMED"
  case few = "LITTLE"
  case none = "NOT_BLOOMED"
}
