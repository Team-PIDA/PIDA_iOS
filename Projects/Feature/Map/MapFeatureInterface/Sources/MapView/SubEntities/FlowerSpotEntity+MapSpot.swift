//
//  FlowerSpotEntity+MapSpot.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/11/26.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import FlowerSpotClient
import BloomingClient
import DesignKit

public extension FlowerSpotEntity {
  var asMapSpot: MapSpotEntity {
    MapSpotEntity(
      id: id,
      pinPoint: pinPoint,
      path: path,
      type: .flower,
      bloomStatus: BloomStatus(rawValue: bloomingStatus) ?? .notBloomed
    )
  }
}
