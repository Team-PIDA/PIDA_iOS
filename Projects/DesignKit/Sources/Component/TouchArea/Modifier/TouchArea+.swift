//
//  TouchArea+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension TouchArea {
  /// 버튼이 탭되었을 때 실행될 동작을 설정합니다.
  /// - Parameter action: 버튼이 탭되었을 때 실행될 클로저입니다.
  /// - Returns: 지정된 동작이 적용된 수정된 버튼을 반환합니다.
  func action(
    _ action: @escaping () async -> Void
  ) -> Self {
    var button = self
    button.action = action
    return button
  }
  
  /// 버튼의 크기를 설정합니다.
  /// - Parameter size: 버튼에 적용될 크기 프리셋입니다 (large, medium, small).
  /// - Returns: 지정된 크기가 적용된 수정된 버튼을 반환합니다.
  func size(
    _ size: IconSize
  ) -> Self {
    var button = self
    button.size = size
    return button
  }
  
  /// 버튼 이미지의 색상을 설정합니다.
  /// - Parameter color: 버튼 이미지에 적용될 색상입니다.
  /// - Returns: 지정된 색상이 적용된 수정된 버튼을 반환합니다.
  func color(
    _ color: Color
  ) -> Self {
    var button = self
    button.color = color
    return button
  }
}
