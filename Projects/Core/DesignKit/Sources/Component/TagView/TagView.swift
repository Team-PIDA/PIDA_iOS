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
  
  public init(text: String) {
    self.text = text
  }
  
  public var body: some View {
    Text(text)
      .fontStyle(FontSet.Caption.caption1)
      .foregroundColor(ColorSet.Text.Secondary)
      .padding(.horizontal, .Number6)
      .padding(.vertical, .Number2)
      .background(ColorSet.Background.Tertiary)
      .cornerRadius(.Number4)
  }
}
