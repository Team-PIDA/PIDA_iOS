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
  /// 꽃 명소 상세 화면
  case flowerSpotDetail(spotId: Int)

  /// 특정 위치로 지도 이동
  case mapLocation(latitude: Double, longitude: Double)

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
      guard let spotId = userInfo[DeepLinkKey.spotId.rawValue] as? Int else { return nil }
      return .flowerSpotDetail(spotId: spotId)

    case .mapLocation:
      guard let latitude = userInfo[DeepLinkKey.latitude.rawValue] as? Double,
            let longitude = userInfo[DeepLinkKey.longitude.rawValue] as? Double else { return nil }
      return .mapLocation(latitude: latitude, longitude: longitude)

    case .setting:
      return .setting
    }
  }
}
