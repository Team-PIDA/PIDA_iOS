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
  var geom: CategoryLineStringGeomDTO?
  var region: String
  var thumbnailUrl: String?
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
    let path = (try? self.geom?.toEntity()) ?? []
    
    return CategoryItemEntity(
      id: id,
      name: name,
      address: address,
      description: description,
      pinPoint: coordinate,
      path: path,
      region: region,
      imageURL: thumbnailUrl,
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

struct CategoryLineStringGeomDTO: DTO {
  typealias Entity = [Coordinate]?
  var type: String
  var coordinates: [[Double]]
  
  init(
    type: String,
    coordinates: [[Double]]
  ) {
    self.type = type
    self.coordinates = coordinates
  }
}

extension CategoryLineStringGeomDTO {
  func toEntity() throws -> [Coordinate]? {
    let points = coordinates.compactMap { coord -> Coordinate? in
      guard coord.count == 2 else { return nil }
      
      return Coordinate(latitude: coord[1], longitude: coord[0])
    }
    return points.isEmpty ? nil : points
  }
}
