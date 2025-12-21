//
//  UpdateBloomingBody.swift
//  BloomingDataInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

struct UpdateBloomingBody: Encodable {
  let flowerSpotId: Int
  let status: String
  
  init(flowerSpotId: Int, status: String) {
    self.flowerSpotId = flowerSpotId
    self.status = status
  }
}
