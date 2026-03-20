//
//  CategoryLineStringGeomDTO.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct CategoryLineStringGeomDTO: DTO {
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

extension CategoryLineStringGeomDTO {
  func toEntity() throws -> [Coordinate]? {
    let points = coordinates.compactMap { coord -> Coordinate? in
      guard coord.count == 2 else { return nil }
      
      return Coordinate(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
}
