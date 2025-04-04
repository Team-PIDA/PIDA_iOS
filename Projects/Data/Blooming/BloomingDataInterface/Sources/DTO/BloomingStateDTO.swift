//
//  BloomingStateDTO.swift
//  BloomingDataInterface
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import BloomingDomainInterface
import Networker
import DesignKit

public struct BloomingStateDTO: DTO {
  public typealias Entity = BloomStatusEntity
  
  public let totalCount: Int
  public let details: [String: [String: StatusData]]
  
  public struct StatusData: Decodable & Sendable{
    public let peopleCount: Int
    public let percentage: Int
  }
}

extension BloomingStateDTO {
  public func toEntity() -> BloomStatusEntity {
    let dayStatuses = details.map { (date, statusDict) in
      var bloomed: StatusTypeData = .init(peopleCount: 0, percentage: 0)
      var withered: StatusTypeData = .init(peopleCount: 0, percentage: 0)
      var little: StatusTypeData = .init(peopleCount: 0, percentage: 0)
      statusDict.forEach { (key, value) in
        let state = BloomStatus(rawValue: key)
        switch state {
        case .bloomed:
          bloomed = .init(peopleCount: value.peopleCount, percentage: value.percentage)
        case .little:
          little = .init(peopleCount: value.peopleCount, percentage: value.percentage)
        case .withered:
          withered = .init(peopleCount: value.peopleCount, percentage: value.percentage)
        default: break
        }
      }
      return DayStatus(
        date: date,
        bloomed: bloomed,
        withered: withered,
        little: little
      )
    }
      .sorted { $0.date > $1.date }
    
    return BloomStatusEntity(
      totalCount: totalCount,
      dayStatuses: dayStatuses
    )
  }
}
