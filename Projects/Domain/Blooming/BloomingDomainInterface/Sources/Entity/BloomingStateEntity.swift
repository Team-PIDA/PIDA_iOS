//
//  BloomingStateEntity.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct BloomStatusEntity: Equatable {
  public let totalCount: Int
  public let nickname: String?
  public let updateAt: String?
  public let dayStatuses: [DayStatus]
  
  public init(
    totalCount: Int,
    nickname: String? = nil,
    updateAt: String? = nil,
    dayStatuses: [DayStatus]
  ) {
    self.totalCount = totalCount
    self.nickname = nickname
    self.updateAt = updateAt
    self.dayStatuses = dayStatuses
  }
}
