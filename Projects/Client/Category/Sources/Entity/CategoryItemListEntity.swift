//
//  CategoryItemListEntity.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import CoreLocation
import Shared

public struct CategoryItemListEntity: Equatable, Sendable {
  public let categoryId: Int
  public let categoryType: CategoryType
  public let list: [CategoryItemEntity]
}

public struct CategoryItemEntity: Equatable, Sendable, Identifiable {
  public let id: Int
  public let name: String
  public let address: String?
  public var recentlyVisitedCount: Int?
  public var bloomingStatus: String
  public let description: String?
  public let pinPoint: Coordinate
  public let path: [Coordinate]
  public let region: Region?
  public let imageURL: String?
  public let homepageUrl: String?
  public let mapUrl: String?
  public let startDate: Date?
  public let endDate: Date?
  public let flowerSpotId: Int?
  public let badges: [CategoryBadgeEntity]

  public var recentlyVisitedCountString: String {
    "최근 방문 \(recentlyVisitedCount ?? 0)회"
  }
  
  public var period: String? {
    if let startDate = startDate?.toString(format: .dateWithWeekday),
       let endDate = endDate?.toString(format: .dateWithWeekday) {
      return "\(startDate) ~ \(endDate)"
    }
    return nil
  }
}

public struct CategoryBadgeEntity: Equatable, Sendable {
  public let type: String
  public let label: String
}
