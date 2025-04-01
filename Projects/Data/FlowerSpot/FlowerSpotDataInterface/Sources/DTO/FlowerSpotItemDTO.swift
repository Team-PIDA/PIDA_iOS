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
import Utility
import DesignKit

public struct FlowerSpotItem: DTO {
  public typealias Entity = FlowerSpot
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
  
}

extension FlowerSpotItem {
  public func toEntity() throws -> FlowerSpot {
    guard let pinPoint = self.pinPoint,
          let pinPoint = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(PointGeomDTO.self)
    }
    let path = try? self.geom?.toEntity()
    return .init(
      id: self.id,
      address: self.address ?? "",
      recentlyVisitedCount: self.recentlyVisitedCount ?? 0,
      bloomingStatus: BloomStatus(rawValue: self.bloomingStatus) ?? .notBloomed,
      streetName: self.streetName ?? "",
      district: self.district ?? "",
      path: path ?? [],
      pinPoint: pinPoint,
      region: self.region ?? ""
    )
  }
}
