//
//  Coordinate.swift
//  Shared
//
//  Created by Jiyeon on 12/28/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import CoreLocation

public struct Coordinate: Equatable, Sendable, Codable {
    public var latitude: Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
      self.latitude = latitude
      self.longitude = longitude
    }
    
    public func distance(from point: Coordinate) -> Double {
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
    
    public func boundingBoxForRadius(radiusInKm: Double) -> [Coordinate] {
      let latitudeDelta = radiusInKm / 111.0
      let longitudeDelta = radiusInKm / (111.0 * cos(latitude * .pi / 180.0))
      
      let southWest = Coordinate(
        latitude: latitude - latitudeDelta,
        longitude: longitude - longitudeDelta
      )
      let northEast = Coordinate(
        latitude: latitude + latitudeDelta,
        longitude: longitude + longitudeDelta
      )
      
      return [southWest, northEast]
    }
}
