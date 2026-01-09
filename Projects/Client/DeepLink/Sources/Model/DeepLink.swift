//
//  DeepLink.swift
//  DeepLinkClient
//
//  Created by 조용인
//  Copyright © com.pida.me. All rights reserved.
//

import Foundation

/// 앱 내 딥링크 목적지 정의
/// 푸시 알림, URL Scheme 등에서 사용
public enum DeepLink: Equatable, Sendable {
  /// 꽃 명소 상세 화면 (위치 이동 + 마커 표시 + 상세 정보 로드)
  case flowerSpotDetail(spotId: Int)

  /// 설정 화면
  case setting
}

// MARK: - Push Notification Payload Parsing

public extension DeepLink {
  /// 푸시 알림 userInfo에서 DeepLink 파싱
  /// - Parameter userInfo: 푸시 알림 payload
  /// - Returns: 파싱된 DeepLink (파싱 실패 시 nil)
  static func from(userInfo: [AnyHashable: Any]) -> DeepLink? {
    guard let typeString = userInfo[DeepLinkKey.type.rawValue] as? String,
          let type = DeepLinkType(rawValue: typeString) else {
      return nil
    }

    switch type {
    case .flowerSpot:
      guard let spotId = userInfo[DeepLinkKey.spotId.rawValue] as? Int,
            spotId > 0 else { return nil }
      return .flowerSpotDetail(spotId: spotId)

    case .setting:
      return .setting
    }
  }
}
