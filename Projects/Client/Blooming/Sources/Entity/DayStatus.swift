//
//  DayStatus.swift
//  BloomingClient
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public struct DayStatus: Identifiable, Equatable {
  public let id: String
  public let date: String
  public let bloomed: StatusData
  public let withered: StatusData
  public let little: StatusData
  public let maxValue: Int
  
  public struct StatusData: Decodable & Sendable{
    let peopleCount: Int
    let percentage: Int
    
    init(peopleCount: Int = 0, percentage: Int = 0) {
      self.peopleCount = 0
      self.percentage = 0
    }
  }
  
  public init(
    date: String,
    bloomed: StatusData?,
    withered: StatusData?,
    little: StatusData?
  ) {
    self.id = date
    self.date = date
    self.bloomed = bloomed ?? .init()
    self.withered = withered ?? .init()
    self.little = little ?? .init()
    self.maxValue = max(
      self.bloomed.peopleCount,
      self.withered.peopleCount,
      self.little.peopleCount
    )
  }
}

extension DayStatus {
  public static func == (lhs: DayStatus, rhs: DayStatus) -> Bool { lhs.id == rhs.id }
}
