//
//  DayStatus.swift
//  BloomingDomainInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct DayStatus: Identifiable, Equatable {
  
  public var id: String { date }
  public let date: String
  public let bloomed: StatusTypeData
  public let withered: StatusTypeData
  public let little: StatusTypeData
  public let maxValue: Int
  
  public init(
    date: String,
    bloomed: StatusTypeData?,
    withered: StatusTypeData?,
    little: StatusTypeData?
  ) {
    self.date = date
    self.bloomed = bloomed ?? .init(peopleCount: 0, percentage: 0)
    self.withered = withered ?? .init(peopleCount: 0, percentage: 0)
    self.little = little ?? .init(peopleCount: 0, percentage: 0)
    self.maxValue = max(
      self.bloomed.peopleCount,
      self.withered.peopleCount,
      self.little.peopleCount
    )
  }
}

extension DayStatus {
  public static func == (lhs: DayStatus, rhs: DayStatus) -> Bool {
    return lhs.id == rhs.id
  }
}
