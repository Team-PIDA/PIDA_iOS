//
//  BloomingEndPoint.swift
//  BloomingDataInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import Networker
import UserDefault

public struct BloomingEndPoint: Sendable {
  static let baseURL = "https://api.pida.me/api/v1"
  
  public static func updateBlooming(body: UpdateBloomingBody) -> Endpoint<BasicDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken ?? ""),
      method: .post,
      baseURL: baseURL,
      path: "/blooming",
      parameters: .body(body)
    )
  }
  
}
