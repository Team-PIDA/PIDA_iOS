//
//  RegionInfoEntity.swift
//  SearchClient
//
//  Created by Jiyeon on 1/13/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct RegionInfoEntity: Equatable, Sendable, Codable {
  public var name: String
  public var coordinate: Coordinate
  
  public init(name: String, coordinate: Coordinate) {
    self.name = name
    self.coordinate = coordinate
  }
  
}
