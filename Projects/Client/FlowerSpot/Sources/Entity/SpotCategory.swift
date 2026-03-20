//
//  SpotCategory.swift
//  FlowerSpotClient
//
//  Created by 조용인
//

import Foundation

/// 장소 상세 카테고리
public enum SpotCategory: String, Equatable, Sendable, Codable {
  /// 산책길 (기존 꽃길)
  case trail
  /// 축제/이벤트
  case festival
  /// 카페
  case cafe
}

// MARK: - categoryLabel 변환

public extension SpotCategory {
  /// 서버 categoryLabel → SpotCategory
  static func from(categoryLabel: String) -> SpotCategory {
    switch categoryLabel {
    case "EVENT": return .festival
    case "CAFE": return .cafe
    default: return .trail
    }
  }
}

// MARK: - 상세페이지 섹션 표시 규칙

public extension SpotCategory {
  /// 나무 종류 섹션 표시 여부
  var showsTreeTypeSection: Bool { self != .festival }
  /// 도보 시간 텍스트 표시 여부
  var showsWalkingTime: Bool { self != .festival }
  /// 제보자 배너 표시 여부
  var showsInformantBanner: Bool { self == .trail }
  /// 방문 횟수 표시 여부
  var showsVisitCount: Bool { self != .festival }
}
