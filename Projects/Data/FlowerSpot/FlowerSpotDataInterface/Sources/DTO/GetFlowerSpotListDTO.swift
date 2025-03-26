//
//  GetFlowerSpotListDTO.swift
//
//  FlowerSpot
//
//  Created by yongin
//

import Foundation
import Networker
import FlowerSpotDomainInterface

public struct GetFlowerSpotListDTO: DTO {
  public typealias Entity = FlowerSpotListEntity
  
  public var list: [List]?
  
}

extension GetFlowerSpotListDTO {
  public func toEntity() throws -> FlowerSpotListEntity {
    guard let list = list else { return FlowerSpotListEntity(itemList: []) }
    let items = list.compactMap {
      try? $0.toEntity()
    }
    return FlowerSpotListEntity(itemList: items)
  }
}

public struct List: DTO {
  public typealias Entity = FlowerSpot?
  public var id: Int
  public var address: String?
  public var recentlyVisitedCount: Int?
  public var bloomingStatus: String
  public var streetName: String?
  public var district: String?
  public var description: String?
  public var geom: LineStringGeom?
  public var pinPoint: PointGeom?
  public var region: String?
  public var deletedAt: String?
  
  public func toEntity() throws -> FlowerSpot? {
    guard let pinPoint = self.pinPoint,
            let pinPoint = try? pinPoint.toEntity() else { return nil }
    let path = try? self.geom?.toEntity()
    return .init(
      id: self.id,
      recentlyVisitedCount: self.recentlyVisitedCount ?? 0,
      bloomingStatus: FlowerStatus(rawValue: self.bloomingStatus) ?? .none,
      streetName: self.streetName ?? "",
      path: path ?? [],
      pinPoint: pinPoint,
      region: self.region ?? ""
    )
  }
}

public struct PointGeom: DTO {
  public typealias Entity = MapPoint?
  public var type: String
  public var coordinates: [Double]
  
  public init(type: String, coordinates: [Double]) {
    self.type = type
    self.coordinates = coordinates
  }
  
  public func toEntity() throws -> MapPoint? {
    if coordinates.count < 2 { return nil }
    return MapPoint(latitude: coordinates[1], longitude: coordinates[0])
  }
}

public struct LineStringGeom: DTO {
  public typealias Entity = [MapPoint]?
  public var type: String
  public var coordinates: [[Double]]
  
  public init(type: String, coordinates: [[Double]]) {
    self.type = type
    self.coordinates = coordinates
  }
  public func toEntity() throws -> [MapPoint]? {
    let points = coordinates.compactMap { coord -> MapPoint? in
      guard coord.count == 2 else { return nil }
      return MapPoint(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
}
