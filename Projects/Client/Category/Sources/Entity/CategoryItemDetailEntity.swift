//
//  CategoryItemDetailEntity.swift
//  CategoryClient
//
//  Created by 조용인
//

import Foundation
import FlowerSpotClient
import BloomingClient

/// v2 카테고리 상세 API 응답을 기존 Entity 구조로 변환한 래퍼
public struct CategoryItemDetailEntity: Equatable, Sendable {
  public let categoryId: Int
  public let spotCategory: SpotCategory
  public let flowerSpotData: FlowerSpotEntity
  public let bloomingStatus: BloomStatusEntity
  public let festivalInfo: FestivalInfoEntity?
  public let cafeInfo: CafeInfoEntity?
  public let badges: [CategoryBadgeEntity]

  public init(
    categoryId: Int,
    spotCategory: SpotCategory,
    flowerSpotData: FlowerSpotEntity,
    bloomingStatus: BloomStatusEntity,
    festivalInfo: FestivalInfoEntity? = nil,
    cafeInfo: CafeInfoEntity? = nil,
    badges: [CategoryBadgeEntity] = []
  ) {
    self.categoryId = categoryId
    self.spotCategory = spotCategory
    self.flowerSpotData = flowerSpotData
    self.bloomingStatus = bloomingStatus
    self.festivalInfo = festivalInfo
    self.cafeInfo = cafeInfo
    self.badges = badges
  }
}
