//
//  ListDTO.swift
//  FlowerSpotDataInterface
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import FlowerSpotDomainInterface

public struct FlowerSpotItem: DTO {
  public typealias Entity = FlowerSpot?
  public var id: Int
  public var address: String?
  public var recentlyVisitedCount: Int?
  public var bloomingStatus: String
  public var streetName: String?
  public var district: String?
  public var description: String?
  public var geom: LineStringGeomDTO?
  public var pinPoint: PointGeomDTO?
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
