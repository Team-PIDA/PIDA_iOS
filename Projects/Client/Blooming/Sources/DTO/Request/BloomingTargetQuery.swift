//
//  BloomingTargetQuery.swift
//  BloomingClient
//
//  Created by 조용인
//

import Foundation

/// query 기반 blooming API용 (flowerSpotId / flowerEventId 중 하나 전달)
public struct BloomingTargetQuery: Encodable, Sendable {
  public let flowerSpotId: Int?
  public let flowerEventId: Int?

  public init(flowerSpotId: Int? = nil, flowerEventId: Int? = nil) {
    self.flowerSpotId = flowerSpotId
    self.flowerEventId = flowerEventId
  }
}
