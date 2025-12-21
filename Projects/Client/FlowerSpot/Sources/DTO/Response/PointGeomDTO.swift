//
//  PointGeomDTO.swift
//  FlowerSpotDataInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient

struct PointGeomDTO: DTO {
  typealias Entity = MapPointEntity?
  var type: String
  var coordinates: [Double]
  
  init(
    type: String,
    coordinates: [Double]
  ) {
    self.type = type
    self.coordinates = coordinates
  }
}

extension PointGeomDTO {
  func toEntity() throws -> MapPointEntity? {
    if coordinates.count < 2 { return nil }
    return MapPointEntity(latitude: coordinates[1], longitude: coordinates[0])
  }
}
