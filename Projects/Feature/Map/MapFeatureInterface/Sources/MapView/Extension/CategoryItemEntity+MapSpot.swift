//
//  CategoryItemEntity+MapSpot.swift
//  MapFeatureInterface
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import CategoryClient
import DesignKit

public extension CategoryItemListEntity {
  var asMapSpot: [MapSpotEntity] {
    self.list.map {
      .init(
        id: $0.id,
        pinPoint: $0.pinPoint,
        path: $0.path,
        type: categoryType.spotType,
        bloomStatus: BloomStatus(rawValue: $0.bloomingStatus) ?? .notBloomed
      )
    }
  }
}
