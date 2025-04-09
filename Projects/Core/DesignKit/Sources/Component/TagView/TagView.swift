//
//  TagView.swift
//  DesignKit
//
//  Created by 조용인 on 3/31/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct TagView: View {
  public let text: String
  
  var icon: Icon? = nil
  
  public init(text: String) {
    self.text = text
  }
  
  public var body: some View {
    HStack(spacing: .Number2) {
      icon
      Text(text)
        .fontStyle(FontSet.Caption.caption1)
        .foregroundColor(ColorSet.Text.Secondary)
    }
    .padding(.horizontal, .Number6)
    .padding(.vertical, .Number2)
    .cornerRadius(.Number4)
    .background(ColorSet.Background.Tertiary)
  }
}

#Preview {
  TagPreview()
}

struct TagPreview: View {
  var body: some View {
    HStack {
      TagView(text: "아이콘 없슴둥")
      TagView(text: "아이콘 있슴둥")
        .icon(.flower)
    }
    
  }
}
