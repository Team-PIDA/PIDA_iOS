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
struct SettingItemView: View {
  
  private let item: SettingItem
  private var action: ((SettingType) async -> Void)?
  
  init(item: SettingItem) {
    self.item = item
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: .Number2) {
        Text(item.title)
          .fontStyle(FontStyle.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        if let subtitle = item.subtitle {
          Text(subtitle)
            .fontStyle(FontStyle.Caption.caption1)
            .lineSpacing(20)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
      }
      Spacer()
      if let trailingText = item.trailing {
        Text(trailingText)
          .fontStyle(FontStyle.Label.label2)
          .foregroundStyle(ColorSet.Text.Accent)
      }
    }
    .padding(.vertical, .Number12)
    .padding(.horizontal, .Number16)
    .contentShape(Rectangle())
    .onTapGesture {
      if let action = action {
        Task { @MainActor in
          await action(item.type)
        }
      }
    }
  }
}

extension SettingItemView {
  func action(_ action: ((SettingType) async -> Void)?) -> Self {
    var content = self
    content.action = action
    return content
  }
}
