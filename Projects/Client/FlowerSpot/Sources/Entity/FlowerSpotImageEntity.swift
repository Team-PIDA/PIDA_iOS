//
//  FlowerSpotImageEntity.swift
//  FlowerSpotClient
//
//  Created by 조용인
//  Copyright © 2026 com.yongin.pida. All rights reserved.
//

import Foundation

public struct FlowerSpotImageEntity: Equatable, Sendable, Codable {
  public let url: String
  public let createdAt: Date?

  public init(url: String, createdAt: Date? = nil) {
    self.url = url
    self.createdAt = createdAt
  }
}
