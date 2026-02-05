//
//  PlaceSearchEntity.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import CacheClient
import Shared

public struct PlaceSearchEntity: Equatable, Sendable, Codable {
  public var name: String
  public var address: String?
  public var coordinate: Coordinate?
  public var region: String?
  public var searchType: SearchType
  public var subInfo: String?
  public var flowerSpotId: Int?
  
  /// 캐시에서 동일 데이터 식별하기 위한 식별자
  public var identifier: String {
    return (coordinate?.toString() ?? "") + name
  }
  
  public init(
    name: String,
    address: String? = nil,
    coordinate: Coordinate,
    region: String,
    searchType: SearchType = .flowerSpot,
    subInfo: String? = nil,
    flowerSpotId: Int? = nil
  ) {
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.region = region
    self.searchType = searchType
    self.subInfo = subInfo
    self.flowerSpotId = flowerSpotId
  }
}
