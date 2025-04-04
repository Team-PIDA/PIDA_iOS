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
  public static func updateBlooming(body: UpdateBloomingBody) -> Endpoint<BasicDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken),
      method: .post,
      path: "/blooming",
      parameters: .body(body)
    )
  }
  
  public static func getBloomingState(id: Int) -> Endpoint<BloomingStateDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken),
      method: .get,
      path: "/blooming/\(id)/details"
    )
  }
  
  public static func verifyBloomingToday(id: Int) -> Endpoint<VerifyBloomingStateDTO> {
    return Endpoint(
      headers: .authorization(UserDefault.accessToken),
      method: .get,
      path: "/blooming/\(id)/verify/today"
    )
  }
}
