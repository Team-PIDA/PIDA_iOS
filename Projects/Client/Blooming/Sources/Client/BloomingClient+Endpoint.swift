//
//  BloomingClient+Endpoint.swift
//  BloomingClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import APIClient
import Shared

struct BloomingEndPoint: Sendable {
  static func updateBlooming(body: UpdateBloomingBody) -> Endpoint<UpdateBloomingStateDTO> {
    return Endpoint(
      headers: .authorization,
      method: .post,
      path: "/blooming",
      parameters: .body(body)
    )
  }
  
  static func getBloomingState(id: Int) -> Endpoint<BloomingStateDTO> {
    return Endpoint(
      headers: .authorization,
      method: .get,
      path: "/blooming/\(id)/details"
    )
  }
  
  static func verifyBloomingToday(id: Int) -> Endpoint<VerifyBloomingStateDTO> {
    return Endpoint(
      headers: .authorization,
      method: .get,
      path: "/blooming/\(id)/verify/today"
    )
  }

  // MARK: - Query 기반 (flowerEventId 지원)

  static func getBloomingStateByTarget(query: BloomingTargetQuery) -> Endpoint<BloomingStateDTO> {
    return Endpoint(
      headers: .authorization,
      method: .get,
      path: "/blooming/details",
      parameters: .query(query)
    )
  }

  static func verifyBloomingTodayByTarget(query: BloomingTargetQuery) -> Endpoint<VerifyBloomingStateDTO> {
    return Endpoint(
      headers: .authorization,
      method: .get,
      path: "/blooming/verify/today",
      parameters: .query(query)
    )
  }
}
