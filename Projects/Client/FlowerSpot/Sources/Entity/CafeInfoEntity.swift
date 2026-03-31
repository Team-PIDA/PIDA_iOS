//
//  CafeInfoEntity.swift
//  FlowerSpotClient
//
//  Created by 조용인
//

import Foundation

/// 카페 카테고리 전용 정보
public struct CafeInfoEntity: Equatable, Sendable {
  /// 장소 카테고리 라벨 (e.g., "카페")
  public var categoryLabel: String
  /// 웹사이트 URL
  public var websiteURL: String?
  /// 썸네일 이미지 URL
  public var thumbnailURL: String?

  public init(
    categoryLabel: String = "카페",
    websiteURL: String? = nil,
    thumbnailURL: String? = nil
  ) {
    self.categoryLabel = categoryLabel
    self.websiteURL = websiteURL
    self.thumbnailURL = thumbnailURL
  }
}
