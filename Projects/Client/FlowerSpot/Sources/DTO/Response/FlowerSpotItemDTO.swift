//
//  FlowerSpotItemDTO.swift
//  FlowerSpotClient
//
//  Created by Jiyeon on 3/28/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import APIClient
import Shared

struct FlowerSpotImageDTO: Codable {
  var url: String
  var createdAt: String?

  func toEntity() -> FlowerSpotImageEntity {
    var date: Date? = nil
    if let createdAt = createdAt {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      date = formatter.date(from: createdAt)
      if date == nil {
        formatter.formatOptions = [.withInternetDateTime]
        date = formatter.date(from: createdAt)
      }
    }
    return FlowerSpotImageEntity(url: url, createdAt: date)
  }
}

struct FlowerSpotItemDTO: DTO {
  typealias Entity = FlowerSpotEntity
  var id: Int
  var address: String?
  var recentlyVisitedCount: Int?
  var bloomingStatus: String
  var streetName: String?
  var district: String?
  var description: String?
  var geom: LineStringGeomDTO?
  var pinPoint: PointGeomDTO?
  var region: String?
  var imageUrls: [String]?
  var images: [FlowerSpotImageDTO]?
  var deletedAt: String?
  var previewUrl: String?
}

extension FlowerSpotItemDTO {
  func toEntity() throws -> FlowerSpotEntity {
    guard let pinPoint = self.pinPoint,
          let pinPoint = try? pinPoint.toEntity() else {
      throw FoundationError.failedToDecode(PointGeomDTO.self)
    }
    let path = (try? self.geom?.toEntity()) ?? []
    let address = self.address ?? ""
    let recentlyVisitedCount = self.recentlyVisitedCount ?? 0
    let bloomingStatus = self.bloomingStatus
    let streetName = self.streetName ?? ""
    let description = self.description ?? "나무 정보 없음"
    let district = self.district ?? ""
    let region = self.region ?? ""

    // images가 있으면 사용, 없으면 imageUrls로 폴백
    let images: [FlowerSpotImageEntity]
    if let imagesDTO = self.images, !imagesDTO.isEmpty {
      images = imagesDTO.map { $0.toEntity() }
    } else {
      images = (self.imageUrls ?? []).map { FlowerSpotImageEntity(url: $0) }
    }

    return .init(
      id: self.id,
      address: address,
      recentlyVisitedCount: recentlyVisitedCount,
      bloomingStatus: bloomingStatus,
      streetName: streetName,
      district: district,
      description: description,
      path: path,
      pinPoint: pinPoint,
      region: region,
      images: images,
      previewUrl: previewUrl
    )
  }
}
