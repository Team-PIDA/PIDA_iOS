//
//  BloomingStateDTO.swift
//  BloomingClient
//
//  Created by 조용인 on 4/3/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct BloomingStateDTO: DTO {
  typealias Entity = BloomStatusEntity
  
  let totalCount: Int
  let details: [String: [String: StatusData]]
  let nickname: String?
  let updatedAt: String?
  
  struct StatusData: Decodable & Sendable{
    let peopleCount: Int
    let percentage: Int
  }
}

extension BloomingStateDTO {
  func toEntity() -> BloomStatusEntity {
    let dayStatuses = details.map { (date, statusDict) in
      var bloomed = DayStatus.StatusData()
      var withered = DayStatus.StatusData()
      var little = DayStatus.StatusData()
      statusDict.forEach { (key, value) in
        switch key {
        case "BLOOMED":
          bloomed = .init(peopleCount: value.peopleCount, percentage: value.percentage)
        case "LITTLE":
          little = .init(peopleCount: value.peopleCount, percentage: value.percentage)
        case "WITHERED":
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
      nickname: nickname,
      updatedAt: updatedAt?.relativeText(),
      dayStatuses: dayStatuses
    )
  }
}
