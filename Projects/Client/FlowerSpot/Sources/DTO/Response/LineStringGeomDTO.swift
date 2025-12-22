//
//  LineStringGeomDTO.swift
//  FlowerSpotClient
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct LineStringGeomDTO: DTO {
  typealias Entity = [MapPointEntity]?
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
  func toEntity() throws -> [MapPointEntity]? {
    let points = coordinates.compactMap { coord -> MapPointEntity? in
      guard coord.count == 2 else { return nil }
      
      return MapPointEntity(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
}
