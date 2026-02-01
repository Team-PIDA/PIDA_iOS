//
//  PlaceSearchEntity.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct PlaceSearchEntity: Equatable, Sendable, Codable {
  public var name: String
  public var address: String?
  public var coordinate: Coordinate
  public var region: String
  public var searchType: SearchType
  
  public init(
    name: String,
    address: String? = nil,
    coordinate: Coordinate,
    region: String,
    searchType: SearchType = .street
  ) {
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.region = region
    self.searchType = searchType
  }
}
