//
//  FestivalInfoEntity.swift
//  FlowerSpotClient
//
//  Created by 조용인
//

import Foundation

/// 축제/이벤트 카테고리 전용 정보
public struct FestivalInfoEntity: Equatable, Sendable {
  /// 축제 시작일 (e.g., "2025.04.08(화)")
  public var startDate: String
  /// 축제 종료일 (e.g., "2025.04.12(토)")
  public var endDate: String
  /// 홈페이지 URL
  public var homepageURL: String?
  /// 포스터 이미지 URL
  public var posterImageURL: String?

  public init(
    startDate: String,
    endDate: String,
    homepageURL: String? = nil,
    posterImageURL: String? = nil
  ) {
    self.startDate = startDate
    self.endDate = endDate
    self.homepageURL = homepageURL
    self.posterImageURL = posterImageURL
  }
}
