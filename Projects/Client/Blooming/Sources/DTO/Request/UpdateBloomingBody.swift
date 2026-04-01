//
//  UpdateBloomingBody.swift
//  BloomingClient
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

struct UpdateBloomingBody: Encodable {
  let flowerSpotId: Int?
  let flowerEventId: Int?
  let flowerSpotCafeId: Int?
  let status: String

  init(query: BloomingTargetQuery, status: String) {
    self.flowerSpotId = query.flowerSpotId
    self.flowerEventId = query.flowerEventId
    self.flowerSpotCafeId = query.flowerSpotCafeId
    self.status = status
  }
}
