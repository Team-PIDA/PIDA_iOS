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
import Shared
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
    let path = (try? self.geom?.toEntity()) ?? []
    let address = self.address ?? ""
    let recentlyVisitedCount = self.recentlyVisitedCount ?? 0
    let bloomingStatus = BloomStatus(rawValue: self.bloomingStatus) ?? .notBloomed
    let streetName = self.streetName ?? ""
    let description = self.description ?? "나무 정보 없음"
    let district = self.district ?? ""
    let region = self.region ?? ""
    return .init(
      id: self.id,
      address: address,
      recentlyVisitedCount: recentlyVisitedCount,
      bloomingStatus: bloomingStatus,
      streetName: streetName,
      district: district,
      description: description,
      path: path,
      pinPoint: pinPoint,
      region: region
    )
  }
}
