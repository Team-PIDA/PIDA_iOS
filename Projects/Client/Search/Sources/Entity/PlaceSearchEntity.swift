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

public struct PlaceSearchEntity: Equatable, Sendable, Codable, Identifiable {
  public var uuid: UUID
  public var id: Int
  public var name: String
  public var address: String?
  public var coordinate: Coordinate?
  public var region: String?
  public var searchType: SearchType
  public var subInfo: String?
  
  public init(
    id: Int = 1,
    name: String,
    address: String? = nil,
    coordinate: Coordinate,
    region: String,
    searchType: SearchType = .street,
    subInfo: String? = nil
  ) {
    self.uuid = .init()
    self.id = id
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.region = region
    self.searchType = searchType
    self.subInfo = subInfo
  }
  
  public init(_ entity: SearchAddressCacheModel) {
    self.uuid = .init()
    self.id = entity.id
    self.name = entity.streetName ?? ""
    self.address = entity.address
    self.subInfo = entity.subInfo
    self.searchType = entity.searchType.flatMap { SearchType(rawValue: $0) } ?? .street
    self.coordinate = entity.coordinate
  }
}
