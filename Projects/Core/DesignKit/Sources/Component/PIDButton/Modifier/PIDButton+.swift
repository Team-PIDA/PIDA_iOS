//
//  PIDButton+.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI


public extension PIDButton {
  /// 버튼의 텍스트를 설정합니다.
  /// - Parameter title: 버튼에 표시될 텍스트입니다.
  /// - Returns: 지정된 텍스트가 적용된 수정된 버튼을 반환합니다.
  func title(
    _ title: String
  ) -> Self {
    var button = self
    button.title = title
    return button
  }
  
  /// 버튼의 크기를 설정합니다.
  /// - Parameter size: 버튼에 적용될 크기 프리셋입니다 (large, medium, small).
  /// - Returns: 지정된 크기가 적용된 수정된 버튼을 반환합니다.
  func size(
    _ size: PIDButtonSize
  ) -> Self {
    var button = self
    button.size = size
    return button
  }
  
  /// 버튼이 탭되었을 때 실행될 동작을 설정합니다.
  /// - Parameter action: 버튼이 탭되었을 때 실행될 클로저입니다.
  /// - Returns: 지정된 동작이 적용된 수정된 버튼을 반환합니다.
  func action(
    _ action: @escaping () -> Void
  ) -> Self {
    var button = self
    button.action = action
    return button
  }
  
  /// 버튼의 비활성화 상태를 설정합니다.
  /// - Parameter isDisabled: 버튼의 비활성화 여부를 결정하는 불리언 값입니다.
  /// - Returns: 지정된 비활성화 상태가 적용된 수정된 버튼을 반환합니다.
  func isDisabled(
    _ isDisabled: Bool
  ) -> Self {
    var button = self
    button.isDisabled = isDisabled
    return button
  }
  
  /// 버튼의 에러 상태를 설정합니다.
  /// - Parameter isError: 버튼이 에러 상태로 표시될지 결정하는 불리언 값입니다.
  /// - Returns: 지정된 에러 상태가 적용된 수정된 버튼을 반환합니다.
  func isError(
    _ isError: Bool
  ) -> Self {
    var button = self
    button.isError = isError
    return button
  }
}
