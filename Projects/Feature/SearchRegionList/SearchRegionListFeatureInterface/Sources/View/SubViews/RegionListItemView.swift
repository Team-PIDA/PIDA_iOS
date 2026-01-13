//
//  RegionListItemView.swift
//  SearchRegionListFeature
//
//  Created by Jiyeon on 1/9/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import SwiftUI
import DesignKit

public struct RegionListItemView: View {
  public var body: some View {
    VStack(spacing: .Number12) {
      HStack(alignment: .center, spacing: .Number12) {
        contentView
        Rectangle()
          .frame(width: 72, height: 72)
      }
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(ColorSet.Border.Secondary)
    }
    .padding(.top, .Number12)
  }
  
  @ViewBuilder
  private var contentView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text("석촌호수길")
          .fontStyle(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        Text("서울 송파구 송파나루길")
          .fontStyle(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
        HStack(spacing: .Number4) {
          BloomStateTagView(state: .bloomed)
          TagView(text: "최근 방문 0회")
        }
        .padding(.top, 8)
        
      }
      Spacer()
    }
  }
}
