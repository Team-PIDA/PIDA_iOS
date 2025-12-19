//
//  GetFlowerSpotParameter.swift
//  FlowerSpotDataInterface
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct GetFlowerSpotParameter: Encodable {
  let region: String?
  let swLat: Double?
  let swLng: Double?
  let neLat: Double?
  let neLng: Double?
  
  public init(
    region: String?,
    swLat: Double?,
    swLng: Double?,
    neLat: Double?,
    neLng: Double?
  ) {
    self.region = region
    self.swLat = swLat
    self.swLng = swLng
    self.neLat = neLat
    self.neLng = neLng
  }
}
