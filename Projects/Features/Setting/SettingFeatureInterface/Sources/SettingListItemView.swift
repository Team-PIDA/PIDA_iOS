//
//  SettingListItemView.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

/// 설정 화면의 리스트 아이템
struct SettingListItemView<TrailingContent: View>: View {
  
  private let title: String
  private let subtitle: String?
  var trailingContent: (() -> TrailingContent)?
  private var action: (() async -> Void)?
  
  init(
    title: String,
    subtitle: String? = nil,
    @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() }) {
    self.title = title
    self.subtitle = subtitle
    self.trailingContent = trailingContent
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: subtitle == nil ? .Number0 : .Number4) {
        Text(title)
          .font(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        if let subtitle = subtitle{
          Text(subtitle)
            .font(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
      }
      Spacer()
      trailingContent?()
    }
    .padding(.vertical, .Number12)
    .padding(.horizontal, .Number16)
    .frame(height: subtitle == nil ? .Number48 : .Number68)
    .onTapGesture {
      if let action = action {
        Task { @MainActor in
          await action()
        }
      }
    }
  }
}

extension SettingListItemView {
  func action(_ action: (() async -> Void)?) -> Self {
    var content = self
    content.action = action
    return content
  }
}
