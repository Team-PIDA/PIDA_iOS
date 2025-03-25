//
//  SettingItemListView.swift
//  SettingFeatureInterface
//
//  Created by Jiyeon on 3/24/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit

struct SettingItemListView: View {
  var title: String? = nil
  let items: [SettingItem]
  let onTap: (SettingType) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      if let title = title {
        sectionTitle(title)
      }
      ForEach(items, id: \.self) { item in
        SettingItemView(
          item: item
        )
        .action { type in
          onTap(type)
        }
      }
    }
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(FontSet.Body.body3)
      .foregroundStyle(ColorSet.Text.Secondary)
      .padding(.top, .Number8)
      .padding(.bottom, .Number4)
      .padding(.horizontal, .Number16)
    
  }
}
