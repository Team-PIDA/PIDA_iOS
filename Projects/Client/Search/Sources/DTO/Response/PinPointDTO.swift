//
//  PinPointDTO.swift
//  SearchClient
//
//  Created by Jiyeon on 2/1/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct PinPointDTO: DTO {
  typealias Entity = Coordinate
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

extension PinPointDTO {
  func toEntity() throws -> Coordinate {
    guard coordinates.count >= 2 else {
      throw FoundationError.failedToDecode(PinPointDTO.self)
    }
    return Coordinate(latitude: coordinates[1], longitude: coordinates[0])
  }
}
