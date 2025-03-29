//
//  PointGeomDTO.swift
//  FlowerSpotDataInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import FlowerSpotDomainInterface

public struct PointGeomDTO: DTO {
  public typealias Entity = MapPoint?
  public var type: String
  public var coordinates: [Double]
  
  public init(
    type: String,
    coordinates: [Double]
  ) {
    self.type = type
    self.coordinates = coordinates
  }
}

extension PointGeomDTO {
  public func toEntity() throws -> MapPoint? {
    if coordinates.count < 2 { return nil }
    return MapPoint(latitude: coordinates[1], longitude: coordinates[0])
  }
}
