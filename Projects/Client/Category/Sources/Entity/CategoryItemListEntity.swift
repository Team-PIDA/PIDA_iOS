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
  public let description: String?
  public let pinPoint: Coordinate
  public let path: [Coordinate]
  public let region: String
  public let imageURL: String?
  public let homepageUrl: String?
  public let mapUrl: String?
  public let startDate: Date?
  public let endDate: Date?
  public let flowerSpotId: Int?
  
  public init(
    id: Int,
    name: String,
    address: String?,
    description: String?,
    pinPoint: Coordinate,
    path: [Coordinate] = [],
    region: String,
    imageURL: String?,
    homepageUrl: String?,
    mapUrl: String?,
    startDate: Date?,
    endDate: Date?,
    flowerSpotId: Int?
  ) {
    self.id = id
    self.name = name
    self.address = address
    self.description = description
    self.pinPoint = pinPoint
    self.path = path
    self.region = region
    self.imageURL = imageURL
    self.homepageUrl = homepageUrl
    self.mapUrl = mapUrl
    self.startDate = startDate
    self.endDate = endDate
    self.flowerSpotId = flowerSpotId
  }
}
