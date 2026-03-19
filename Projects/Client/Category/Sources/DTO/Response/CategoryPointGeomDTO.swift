//
//  CategoryPointGeomDTO.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct CategoryPointGeomDTO: DTO {
  var type: String
  var coordinates: [Double]

  func toEntity() throws -> Coordinate {
    guard coordinates.count >= 2 else {
      throw FoundationError.failedToDecode(CategoryPointGeomDTO.self)
    }
    return Coordinate(latitude: coordinates[1], longitude: coordinates[0])
  }
}
