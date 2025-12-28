//
//  LineStringGeomDTO.swift
//  FlowerSpotClient
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct LineStringGeomDTO: DTO {
  typealias Entity = [Coordinate]?
  var type: String
  var coordinates: [[Double]]
  
  init(
    type: String,
    coordinates: [[Double]]
  ) {
    self.type = type
    self.coordinates = coordinates
  }
}

extension LineStringGeomDTO {
  func toEntity() throws -> [Coordinate]? {
    let points = coordinates.compactMap { coord -> Coordinate? in
      guard coord.count == 2 else { return nil }
      
      return Coordinate(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
}
