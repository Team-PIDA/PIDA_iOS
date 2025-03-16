//
//  Icon+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension Icon {
  /// 아이콘의 크기를 설정합니다.
  /// - Parameter size: 아이콘에 적용될 크기 프리셋입니다 (large, medium, small).
  /// - Returns: 지정된 크기가 적용된 수정된 아이콘을 반환합니다.
  func size(
    _ size: IconSize
  ) -> Self {
    var icon = self
    icon.size = size
    return icon
  }
  
  /// 아이콘의 색상을 설정합니다.
  /// - Parameter color: 아이콘에 적용될 색상입니다.
  /// - Returns: 지정된 색상이 적용된 수정된 아이콘을 반환합니다.
  func foregroundColor(
    _ color: Color
  ) -> Self {
    var icon = self
    icon.color = color
    return icon
  }
}
