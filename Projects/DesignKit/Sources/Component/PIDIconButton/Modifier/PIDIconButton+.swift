//
//  PIDIconButton+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension PIDIconButton {
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
  /// - Parameter size: 버튼의 너비와 높이에 적용할 크기 값입니다.
  /// - Returns: 지정된 크기가 적용된 수정된 버튼을 반환합니다.
  func buttonSize(_ size: CGFloat) -> Self {
    var button = self
    button.buttonSize = size
    return button
  }
  
  /// 버튼의 배경 색상을 설정합니다
  /// - Parameter color: 버튼에 적용될 배경 색상입니다.
  /// - Returns: 지정된 배경 색상이 적용된 수정된 버튼을 반환합니다
  func backgroundColor(
    _ color: Color
  ) -> Self {
    var button = self
    button.backgroundColor = color
    return button
  }
}
