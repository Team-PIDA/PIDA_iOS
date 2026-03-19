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
  var list: [CategoryItemResponseDTO]
}

extension CategoryItemListDTO {
  func toEntity() throws -> CategoryItemListEntity {
    let items = try list.map { try $0.toEntity() }
    return CategoryItemListEntity(
      categoryId: categoryId,
      categoryType: CategoryType(rawValue: categoryLabel),
      list: items
    )
  }
}

struct CategoryItemResponseDTO: DTO {
  var id: Int
  var name: String
  var address: String?
  var description: String?
  var pinPoint: CategoryPointGeomDTO
  var region: String
  var homepageUrl: String?
  var mapUrl: String?
  var startDate: String?
  var endDate: String?
  var flowerSpotId: Int?
}

extension CategoryItemResponseDTO {
  func toEntity() throws -> CategoryItemEntity {
    guard let coordinate = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(CategoryPointGeomDTO.self)
    }
    let formatter = Date.formatter(with: .yearMonthDay)
    return CategoryItemEntity(
      id: id,
      name: name,
      address: address,
      description: description,
      pinPoint: coordinate,
      region: region,
      homepageUrl: homepageUrl,
      mapUrl: mapUrl,
      startDate: startDate.flatMap { formatter.date(from: $0) },
      endDate: endDate.flatMap { formatter.date(from: $0) },
      flowerSpotId: flowerSpotId
    )
  }
}

struct CategoryPointGeomDTO: DTO {
  var type: String
  var coordinates: [Double]

  func toEntity() throws -> Coordinate {
    guard coordinates.count >= 2 else {
      throw FoundationError.failedToDecode(CategoryPointGeomDTO.self)
    }
    return Coordinate(latitude: coordinates[1], longitude: coordinates[0])
  }
}
