//
//  FlowerSpotClient+Endpoint.swift
//  FlowerSpotClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import Foundation
import APIClient

struct FlowerSpotEndpoint: Sendable {
  @discardableResult
  static func getFlowerSpotWithArea(
    getFlowerSpotQuery: GetFlowerSpotQuery
  ) -> Endpoint<GetFlowerSpotListDTO> {
    return Endpoint(
      method: .get,
      path:"/flower-spot",
      parameters: .query(getFlowerSpotQuery)
    )
  }
  
  @discardableResult
  static func getFlowerSpotDetail(id: Int) -> Endpoint<FlowerSpotItemDTO> {
    return Endpoint(
      method: .get,
      path:"/flower-spot/\(id)"
    )
  }
}
