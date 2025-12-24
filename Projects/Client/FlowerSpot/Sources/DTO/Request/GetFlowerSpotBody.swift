//
//  GetFlowerSpotQuery.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct GetFlowerSpotQuery: Encodable {
  public let region: String?
  public let swLat: Double?
  public let swLng: Double?
  public let neLat: Double?
  public let neLng: Double?
  
  public init(
    region: String? = nil,
    swLat: Double? = nil,
    swLng: Double? = nil,
    neLat: Double? = nil,
    neLng: Double? = nil
  ) {
    self.region = region
    self.swLat = swLat
    self.swLng = swLng
    self.neLat = neLat
    self.neLng = neLng
  }
}
