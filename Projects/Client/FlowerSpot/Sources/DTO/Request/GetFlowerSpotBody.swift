//
//  GetFlowerSpotQuery.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

struct GetFlowerSpotQuery: Encodable {
  let region: String?
  let swLat: Double?
  let swLng: Double?
  let neLat: Double?
  let neLng: Double?
  
  init(
    region: String? = nil,
    swLat: Double? = nil,
    swLng: Double? = nil,
    neLat: Double? = nil,
    neLng: Double = nil?
  ) {
    self.region = region
    self.swLat = swLat
    self.swLng = swLng
    self.neLat = neLat
    self.neLng = neLng
  }
}
