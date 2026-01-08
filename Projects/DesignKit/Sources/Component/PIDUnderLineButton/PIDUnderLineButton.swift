//
//  PIDUnderLineButton.swift
//  DesignKit
//
//  Created by 조용인 on 1/8/26.
//  Copyright 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

/// 밑줄이 있는 텍스트 버튼
public struct PIDUnderLineButton: View {

  public enum Style {
    case primary   // 청록색 (Accent)
    case secondary // 검정색 (Primary)
    case disabled  // 회색 (Tertiary)
  }

  private let title: String
  private let style: Style
  private let action: () -> Void

  public init(
    title: String,
    style: Style = .secondary,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.style = style
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Text(title)
        .fontStyle(FontSet.Body.body1)
        .foregroundColor(textColor)
        .underline(true, color: textColor)
    }
    .disabled(style == .disabled)
  }

  private var textColor: Color {
    switch style {
    case .primary:
      return ColorSet.Text.Accent
    case .secondary:
      return ColorSet.Text.Primary
    case .disabled:
      return ColorSet.Text.Tertiary
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    PIDUnderLineButton(
      title: "사진 교체",
      style: .primary
    ) {
      print("primary tapped")
    }

    PIDUnderLineButton(
      title: "사진 교체",
      style: .secondary
    ) {
      print("secondary tapped")
    }

    PIDUnderLineButton(
      title: "사진 교체",
      style: .disabled
    ) {
      print("disabled tapped")
    }
  }
  .padding()
}
