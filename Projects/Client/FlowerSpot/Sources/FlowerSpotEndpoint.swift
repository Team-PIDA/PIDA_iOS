//
//  FlowerSpotEndpoint.swift
//  FlowerSpotDataInterface
//
//  Created by 조용인 on 3/26/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker

public struct FlowerSpotEndpoint: Sendable {
  @discardableResult
  public static func getFlowerSpotWithArea(
    getFlowerSpotParameter: GetFlowerSpotParameter
  ) -> Endpoint<GetFlowerSpotListDTO> {
    return Endpoint(
      method: .get,
      path:"/flower-spot",
      parameters: .query(getFlowerSpotParameter)
    )
  }
  
  @discardableResult
  public static func getFlowerSpotDetail(id: Int) -> Endpoint<FlowerSpotItem> {
    return Endpoint(
      method: .get,
      path:"/flower-spot/\(id)"
    )
  }
}
