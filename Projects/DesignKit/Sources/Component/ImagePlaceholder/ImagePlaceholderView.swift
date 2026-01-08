//
//  ImagePlaceholderView.swift
//  DesignKit
//
//  Created by 조용인 on 1/7/26.
//  Copyright © 2026 com.yongin.pida. All rights reserved.
//

import SwiftUI

/// 이미지 로딩 중 또는 로딩 실패 시 표시할 플레이스홀더 뷰
public struct ImagePlaceholderView: View {
  public enum State {
    case loading
    case failure
  }

  public enum Style {
    case light
    case dark
  }

  private let state: State
  private var style: Style = .light

  public init(state: State = .loading) {
    self.state = state
  }

  public var body: some View {
    ZStack {
      backgroundColor

      switch state {
      case .loading:
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: progressTint))
      case .failure:
        Icon(image: .placeholder)
          .size(.superLarge)
          .foregroundColor(iconColor)
      }
    }
  }

  private var backgroundColor: Color {
    switch style {
    case .light: return ColorSet.Background.Tertiary
    case .dark: return Color.black
    }
  }

  private var progressTint: Color {
    switch style {
    case .light: return ColorSet.Gray._300
    case .dark: return .white
    }
  }

  private var iconColor: Color {
    switch style {
    case .light: return ColorSet.Icon.Secondary
    case .dark: return .white.opacity(0.6)
    }
  }

  // MARK: - Style Modifier

  public func style(_ style: Style) -> Self {
    var copy = self
    copy.style = style
    return copy
  }
}

#Preview {
  VStack(spacing: 20) {
    ImagePlaceholderView(state: .loading)
      .frame(width: 160, height: 160)
      .cornerRadius(16)

    ImagePlaceholderView(state: .failure)
      .frame(width: 160, height: 160)
      .cornerRadius(16)
  }
}
