//
//  FontStyleModifier.swift
//  DesignKit
//
//  Created by Jiyeon on 3/25/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct FontStyleModifier: ViewModifier {
  var font: FontInfo
  init(font: FontInfo) {
    self.font = font
  }
  
  public func body(content: Content) -> some View {
    content
      .font(font.font)
      .padding(.vertical, font.lineSpacing/2)
  }
}

extension View {
  public func fontStyle(_ font: FontInfo) -> some View {
    self.modifier(FontStyleModifier(font: font))
  }
}

