//
//  DetailsEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - DetailsEvent

/// 상세 페이지 관련 이벤트
public enum DetailsEvent: AnalyticsEvent {
  /// 상세 페이지 진입
  case start(
    spotId: Int,
    distanceFromSpot: Double?,
    currentBloomStatus: String?,
    visitCount: Int
  )

  /// 하단 '나무 종류' 영역이 화면에 노출됐을 때
  case scrollReachBottom(scrollTimeToReach: Double)

  /// 주소 옆 '복사' 버튼 클릭
  case copyAddress(
    scrollTimeToReach: Double,
    copyAddressCount: Int,
    copyAddressToUpdate: Int
  )

  /// 상단 썸네일 사진 클릭
  case thumbnailClicked(spotPhoto: Int)

  /// 갤러리 화면 진입
  case galleryStart(distanceFromSpot: Double?)

  /// 사진 뷰어 화면 진입
  case viewerStart(distanceFromSpot: Double?)

  public var name: String {
    switch self {
    case .start:
      return "details_start"
    case .scrollReachBottom:
      return "scroll_reach_bottom"
    case .copyAddress:
      return "copy_address"
    case .thumbnailClicked:
      return "details_thumbnail_clicked"
    case .galleryStart:
      return "gallery_start"
    case .viewerStart:
      return "viewer_start"
    }
  }

  public var properties: [String: Any] {
    switch self {
    case let .start(spotId, distanceFromSpot, currentBloomStatus, visitCount):
      var props: [String: Any] = [
        "spot_id": spotId,
        "visit_count": visitCount
      ]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      if let currentBloomStatus {
        props["current_bloom_status"] = currentBloomStatus
      }

      return props

    case let .scrollReachBottom(scrollTimeToReach):
      return ["scroll_time_to_reach": scrollTimeToReach]

    case let .copyAddress(scrollTimeToReach, copyAddressCount, copyAddressToUpdate):
      return [
        "scroll_time_to_reach": scrollTimeToReach,
        "copy_address_count": copyAddressCount,
        "copy_address_to_update": copyAddressToUpdate
      ]

    case let .thumbnailClicked(spotPhoto):
      return ["spot_photo": spotPhoto]

    case let .galleryStart(distanceFromSpot):
      var props: [String: Any] = [:]
      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }
      return props

    case let .viewerStart(distanceFromSpot):
      var props: [String: Any] = [:]
      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }
      return props
    }
  }
}
