//
//  CategoryItemListDTO.swift
//  CategoryClient
//
//  Created by Jiyeon on 3/19/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct CategoryItemListDTO: DTO {
  typealias Entity = CategoryItemListEntity
  var categoryId: Int
  var categoryLabel: String
  var title: String
  var count: Int
  var list: [CategoryItemResponseDTO]
}

extension CategoryItemListDTO {
  func toEntity() throws -> CategoryItemListEntity {
    let items = try list.map { try $0.toEntity() }
    return CategoryItemListEntity(
      categoryId: categoryId,
      categoryType: CategoryType(rawValue: categoryLabel),
      title: title,
      count: count,
      list: items
    )
  }
}

struct CategoryItemResponseDTO: DTO {
  var id: Int
  var name: String
  var address: String?
  var recentlyVisitedCount: Int?
  var bloomingStatus: String
  var description: String?
  var pinPoint: CategoryPointGeomDTO
  var geom: CategoryLineStringGeomDTO?
  var region: String
  var thumbnailUrl: String?
  var homepageUrl: String?
  var mapUrl: String?
  var startDate: String?
  var endDate: String?
  var flowerSpotId: Int?
  var badges: [CategoryBadgeDTO] = []
}

extension CategoryItemResponseDTO {
  func toEntity() throws -> CategoryItemEntity {
    guard let coordinate = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(CategoryPointGeomDTO.self)
    }
    let formatter = Date.formatter(with: .yearMonthDay)
    let path = (try? self.geom?.toEntity()) ?? []
    
    return CategoryItemEntity(
      id: id,
      name: name,
      address: address,
      recentlyVisitedCount: recentlyVisitedCount,
      bloomingStatus: bloomingStatus,
      description: description,
      pinPoint: coordinate,
      path: path,
      region: Region(rawValue: region),
      imageURL: thumbnailUrl,
      homepageUrl: homepageUrl,
      mapUrl: mapUrl,
      startDate: startDate.flatMap { formatter.date(from: $0) },
      endDate: endDate.flatMap { formatter.date(from: $0) },
      flowerSpotId: flowerSpotId,
      badges: try badges.map { try $0.toEntity() }
    )
  }
}

