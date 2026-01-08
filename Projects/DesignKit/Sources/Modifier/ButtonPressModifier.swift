//
//  ButtonPressModifier.swift
//  DesignKit
//
//  Created by 조용인 on 1/8/26.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

/// 버튼 프레스 제스처와 햅틱 피드백을 처리하는 ViewModifier
public struct ButtonPressModifier: ViewModifier {
  @Binding var isPressed: Bool
  let isDisabled: Bool
  let enableHaptic: Bool
  let action: (() async -> Void)?

  public init(
    isPressed: Binding<Bool>,
    isDisabled: Bool = false,
    enableHaptic: Bool = true,
    action: (() async -> Void)?
  ) {
    self._isPressed = isPressed
    self.isDisabled = isDisabled
    self.enableHaptic = enableHaptic
    self.action = action
  }

  public func body(content: Content) -> some View {
    content
      .gesture(
        DragGesture(minimumDistance: .Number0)
          .onChanged { _ in isPressed = true }
          .onEnded { _ in
            isPressed = false
            if let action = action {
              if enableHaptic {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
              }
              Task { @MainActor in
                await action()
              }
            }
          }
      )
      .disabled(isDisabled)
  }
}

extension View {
  /// 버튼 프레스 제스처와 햅틱 피드백을 적용합니다.
  /// - Parameters:
  ///   - isPressed: 프레스 상태 바인딩
  ///   - isDisabled: 비활성화 여부
  ///   - enableHaptic: 햅틱 피드백 활성화 여부 (기본값: true)
  ///   - action: 탭 시 실행할 액션
  public func buttonPress(
    isPressed: Binding<Bool>,
    isDisabled: Bool = false,
    enableHaptic: Bool = true,
    action: (() async -> Void)?
  ) -> some View {
    self.modifier(
      ButtonPressModifier(
        isPressed: isPressed,
        isDisabled: isDisabled,
        enableHaptic: enableHaptic,
        action: action
      )
    )
  }
}
