//
//  SettingItem.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// 설정 리스트에 들어가는 아이템 타입
public struct SettingItem: Hashable {
  public let type: SettingType
  public let title: String
  public let subtitle: String?
  public let trailing: String?
  
  public init(
    type: SettingType,
    title: String,
    subtitle: String? = nil,
    trailing: String? = nil
  ) {
    self.type = type
    self.title = title
    self.subtitle = subtitle
    self.trailing = trailing
  }
}

/// 각 설정 아이템의 타입
///
/// 리스트 탭 이벤트 시 구분하기 위한 타입으로 사용됨
public enum SettingType {
  case update
  case terms
  case privacy
  case logout
  case withdraw
}
