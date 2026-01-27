//
//  MapEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - MapEvent

/// 지도 관련 이벤트
public enum MapEvent: AnalyticsEvent {
  /// 바텀시트 열렸을 때 (꽃길 핀 선택)
  case spotSelected(
    spotId: Int,
    distanceFromSpot: Double?,
    currentBloomStatus: String?,
    visitCount: Int,
    entryPoint: EntryPoint
  )

  /// 우측 하단 '현위치로 이동' 버튼 클릭
  case currentLocationClicked(currentPage: String)

  /// '현 위치에서 재검색' 버튼 클릭
  case researchClicked(currentPage: String)

  /// '현 위치에서 재검색' 버튼 클릭했으나 꽃길이 주변에 없는 경우
  case researchFailed

  /// '제보하기' 버튼 클릭
  case reportClicked

  public var name: String {
    switch self {
    case .spotSelected:
      return "map_spot_selected"
    case .currentLocationClicked:
      return "map_current_location_clicked"
    case .researchClicked:
      return "map_research_clicked"
    case .researchFailed:
      return "map_research_failed"
    case .reportClicked:
      return "map_report_clicked"
    }
  }

  public var properties: [String: Any] {
    switch self {
    case let .spotSelected(spotId, distanceFromSpot, currentBloomStatus, visitCount, entryPoint):
      var props: [String: Any] = [
        "spot_id": spotId,
        "visit_count": visitCount,
        "entry_point": entryPoint.rawValue
      ]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      if let currentBloomStatus {
        props["current_bloom_status"] = currentBloomStatus
      }

      return props

    case let .currentLocationClicked(currentPage):
      return ["current_page": currentPage]

    case let .researchClicked(currentPage):
      return ["current_page": currentPage]

    case .researchFailed, .reportClicked:
      return [:]
    }
  }
}

// MARK: - EntryPoint

public extension MapEvent {
  /// 바텀시트가 열릴 때 사용자가 해당 벚꽃길을 선택하기 이전 경로
  enum EntryPoint: String, Sendable {
    case mapPin = "map_pin"
    case searchRecent = "search_recent"
    case searchKeyword = "search_keyword"
    case searchRegion = "search_region"
    case keyboard = "keyboard"
  }
}
