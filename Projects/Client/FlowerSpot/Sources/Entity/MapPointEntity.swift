//
//  MapPointEntity.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import Shared

public struct MapPointEntity: Equatable, Sendable, Codable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public func distance(from point: MapPointEntity) -> Double {
    let from = CLLocationCoordinate2D(
      latitude: latitude,
      longitude: longitude
    )
    let to = CLLocationCoordinate2D(
      latitude: point.latitude,
      longitude: point.longitude
    )
    return (Double.distanceInKilometers(from: from, to: to) * 10).rounded() / 10
  }
}
