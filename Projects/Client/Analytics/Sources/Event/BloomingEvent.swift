//
//  BloomingEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - BloomingEvent

/// 개화 상태 투표 관련 이벤트
public enum BloomingEvent: AnalyticsEvent {
  /// 투표 화면 진입
  case updateStart(
    spotId: Int,
    distanceFromSpot: Double?
  )

  /// 개화 상태 옵션 중 하나를 터치
  case statusOption(
    distanceFromSpot: Double?,
    statusOption: StatusOption
  )

  /// '한 컷 공유하기' 버튼 터치
  case uploadPhoto(
    distanceFromSpot: Double?,
    isStatusRecorded: Bool
  )

  /// '기록하기' 버튼 눌러 제출 완료
  case statusSubmitted(
    distanceFromSpot: Double?,
    completeDurationSeconds: Double
  )

  public var name: String {
    switch self {
    case .updateStart:
      return "update_start"
    case .statusOption:
      return "bloom_status_option"
    case .uploadPhoto:
      return "upload_photo"
    case .statusSubmitted:
      return "bloom_status_submitted"
    }
  }

  public var properties: [String: Any] {
    switch self {
    case let .updateStart(spotId, distanceFromSpot):
      var props: [String: Any] = ["spot_id": spotId]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      return props

    case let .statusOption(distanceFromSpot, statusOption):
      var props: [String: Any] = ["status_option": statusOption.rawValue]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      return props

    case let .uploadPhoto(distanceFromSpot, isStatusRecorded):
      var props: [String: Any] = ["is_status_recorded": isStatusRecorded]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      return props

    case let .statusSubmitted(distanceFromSpot, completeDurationSeconds):
      var props: [String: Any] = ["complete_duration_seconds": completeDurationSeconds]

      if let distanceFromSpot {
        props["distance_from_spot"] = distanceFromSpot
      }

      return props
    }
  }
}

// MARK: - StatusOption

public extension BloomingEvent {
  /// 개화 상태 옵션
  enum StatusOption: String, Sendable {
    case notYet = "not_yet"           // 아직이에요
    case fullBloom = "full_bloom"     // 만개예요!
    case fallen = "fallen"            // 져물었어요...
  }
}
