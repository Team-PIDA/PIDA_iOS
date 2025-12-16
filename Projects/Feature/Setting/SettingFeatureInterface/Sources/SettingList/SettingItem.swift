//
//  SettingItem.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import DesignKit

/// 설정 리스트에 들어가는 아이템 타입
public struct SettingItem: Hashable {
  public let type: SettingType
  public let title: String
  public let subtitle: String?
  public let trailing: String?
  public let icon: ImageSet?
  
  public init(
    type: SettingType,
    title: String,
    subtitle: String? = nil,
    trailing: String? = nil,
    icon: ImageSet? = nil
  ) {
    self.type = type
    self.title = title
    self.subtitle = subtitle
    self.trailing = trailing
    self.icon = icon
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
  
  case report
  case feedback
}
