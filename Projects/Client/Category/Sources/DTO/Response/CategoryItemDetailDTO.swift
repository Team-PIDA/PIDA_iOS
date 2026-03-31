//
//  CategoryItemDetailDTO.swift
//  CategoryClient
//
//  Created by 조용인
//

import Foundation
import APIClient
import Shared
import BloomingClient
import FlowerSpotClient

// MARK: - Top-level Response

struct CategoryItemDetailDTO: DTO {
  typealias Entity = CategoryItemDetailEntity

  var categoryId: Int
  var categoryLabel: String
  var common: CommonDetailDTO
  var detail: SpecificDetailDTO
}

extension CategoryItemDetailDTO {
  func toEntity() throws -> CategoryItemDetailEntity {
    let spotCategory = SpotCategory.from(categoryLabel: categoryLabel)
    let pinPoint = try common.pinPoint.toEntity()
    let path = (try? detail.flowerSpot?.geom?.toEntity())?.flatMap { $0 } ?? []
    var images = common.imageUrls?.map { $0.toEntity() } ?? []
    // common.imageUrls가 비어있으면 카테고리별 thumbnail을 images에 포함
    if images.isEmpty {
      let thumbnailUrl = detail.event?.thumbnailUrl ?? detail.cafe?.thumbnailUrl
      if let thumbnailUrl {
        images = [FlowerSpotImageEntity(url: thumbnailUrl, createdAt: nil)]
      }
    }
    let recentlyVisitedCount = detail.flowerSpot?.recentlyVisitedCount
      ?? detail.cafe?.recentlyVisitedCount
      ?? 0

    let flowerSpotData = FlowerSpotEntity(
      id: common.id,
      address: common.address,
      recentlyVisitedCount: recentlyVisitedCount,
      bloomingStatus: common.bloomingStatus ?? "NOT_BLOOMED",
      streetName: common.name,
      description: common.description,
      path: path,
      pinPoint: pinPoint,
      region: common.region,
      images: images
    )

    // common.bloomingDetails → BloomStatusEntity
    // SYNC: BloomingStateDTO.toEntity()와 동일한 변환 로직
    let bloomingStatus = common.bloomingDetails.toEntity()

    // detail.event → FestivalInfoEntity
    let festivalInfo = detail.event.map { event in
      let displayFormatter = Date.formatter(with: .dateWithWeekday)
      let parseFormatter = Date.formatter(with: .yearMonthDay)
      let startDateStr = event.startDate
        .flatMap { parseFormatter.date(from: $0) }
        .map { displayFormatter.string(from: $0) } ?? ""
      let endDateStr = event.endDate
        .flatMap { parseFormatter.date(from: $0) }
        .map { displayFormatter.string(from: $0) } ?? ""
      return FestivalInfoEntity(
        startDate: startDateStr,
        endDate: endDateStr,
        homepageURL: event.homepageUrl,
        posterImageURL: event.thumbnailUrl
      )
    }

    // detail.cafe → CafeInfoEntity
    let cafeInfo = detail.cafe.map { cafe in
      CafeInfoEntity(
        categoryLabel: "카페",
        websiteURL: cafe.mapUrl,
        thumbnailURL: cafe.thumbnailUrl
      )
    }

    let badges = common.badges.map { CategoryBadgeEntity(type: $0.type, label: $0.label) }

    return CategoryItemDetailEntity(
      categoryId: categoryId,
      spotCategory: spotCategory,
      flowerSpotData: flowerSpotData,
      bloomingStatus: bloomingStatus,
      festivalInfo: festivalInfo,
      cafeInfo: cafeInfo,
      badges: badges
    )
  }
}

// MARK: - Common Detail

struct CommonDetailDTO: Decodable, Sendable {
  var id: Int
  var name: String
  var address: String?
  var description: String?
  var pinPoint: CategoryPointGeomDTO
  var region: String
  var imageUrls: [CategoryImageDTO]?
  var bloomingStatus: String?
  var badges: [CategoryBadgeDTO] = []
  var bloomingDetails: BloomingDetailsInlineDTO
}

// MARK: - Blooming Details (v2 common에 인라인 포함)
// SYNC: BloomingStateDTO.toEntity()와 동일한 변환 로직

struct BloomingDetailsInlineDTO: Decodable, Sendable {
  var totalCount: Int
  var details: [String: [String: StatusDetailDTO]]
  var nickname: String?
  var updatedAt: String?

  struct StatusDetailDTO: Decodable, Sendable {
    var peopleCount: Int
    var percentage: Int
  }

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
      return DayStatus(date: date, bloomed: bloomed, withered: withered, little: little)
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

// MARK: - Category-specific Detail Payloads

struct SpecificDetailDTO: Decodable, Sendable {
  var event: EventDetailPayloadDTO?
  var cafe: CafeDetailPayloadDTO?
  var flowerSpot: FlowerSpotDetailPayloadDTO?
}

struct EventDetailPayloadDTO: Decodable, Sendable {
  var thumbnailUrl: String?
  var homepageUrl: String?
  var startDate: String?
  var endDate: String?
}

struct CafeDetailPayloadDTO: Decodable, Sendable {
  var thumbnailUrl: String?
  var mapUrl: String?
  var flowerSpotId: Int?
  var recentlyVisitedCount: Int?
}

struct FlowerSpotDetailPayloadDTO: Decodable, Sendable {
  var geom: CategoryLineStringGeomDTO?
  var recentlyVisitedCount: Int?
}

// MARK: - Image DTO

struct CategoryImageDTO: Decodable, Sendable {
  var url: String
  var createdAt: String?

  private static let formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(identifier: "Asia/Seoul")
    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    return f
  }()

  func toEntity() -> FlowerSpotImageEntity {
    let date = createdAt.flatMap { Self.formatter.date(from: $0) }
    return FlowerSpotImageEntity(url: url, createdAt: date)
  }
}
