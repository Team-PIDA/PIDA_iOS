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
}
