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
  
  static let baseURL = "https://api.pida.me/api/v1"
  
  @discardableResult
  public static func getFlowerSpotWithArea(
    getFlowerSpotParameter: GetFlowerSpotParameter
  ) -> Endpoint<GetFlowerSpotListDTO> {
    return Endpoint(
      method: .get,
      baseURL: baseURL,
      path:"/flower-spot",
      parameters: .query(getFlowerSpotParameter)
    )
  }
}
