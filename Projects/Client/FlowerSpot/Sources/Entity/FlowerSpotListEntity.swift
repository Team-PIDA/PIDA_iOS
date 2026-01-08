//
//  FlowerSpotListEntity.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import CoreLocation
import Shared

public struct FlowerSpotListEntity: Equatable, Sendable, Codable {
  public var itemList: [FlowerSpotEntity]
  public init(itemList: [FlowerSpotEntity]) {
    self.itemList = itemList
  }
}


public struct FlowerSpotEntity: Equatable, Sendable, Codable {
  public var id: Int
  public var address: String
  public var recentlyVisitedCount: Int
  public var recentlyVisitedCountString: String
  public var bloomingStatus: String
  public var streetName: String
  public var district: String
  public var description: String
  public var path: [Coordinate]
  public var pinPoint: Coordinate
  public var region: String
  public var imageUrls: [String]

  public init(
    id: Int,
    address: String? = nil,
    recentlyVisitedCount: Int,
    bloomingStatus: String,
    streetName: String,
    district: String? = nil,
    description: String? = nil,
    path: [Coordinate],
    pinPoint: Coordinate,
    region: String,
    imageUrls: [String] = []
  ) {
    self.id = id
    self.address = address ?? "주소 정보 없음"
    self.recentlyVisitedCount = recentlyVisitedCount
    self.recentlyVisitedCountString = "최근 방문 \(self.recentlyVisitedCount)회"
    self.bloomingStatus = bloomingStatus
    self.streetName = streetName
    self.district = district ?? "동네 정보 없음"
    self.description = description ?? "나무 정보 없음"
    self.path = path
    self.pinPoint = pinPoint
    self.region = region
    self.imageUrls = imageUrls
  }
}
