//
//  LineStringGeomDTO.swift
//  FlowerSpotDataInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import FlowerSpotDomainInterface

public struct LineStringGeomDTO: DTO {
  public typealias Entity = [MapPoint]?
  public var type: String
  public var coordinates: [[Double]]
  
  public init(
    type: String,
    coordinates: [[Double]]
  ) {
    self.type = type
    self.coordinates = coordinates
  }
}

extension LineStringGeomDTO {
  
  public func toEntity() throws -> [MapPoint]? {
    let points = coordinates.compactMap { coord -> MapPoint? in
      guard coord.count == 2 else { return nil }
      
      return MapPoint(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
  
}
