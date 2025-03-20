//
//  PIDATextField.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public struct PIDATextField: View {
  @Binding private var text: String
  private let placeholder: String
  public var onSubmit: (() -> Void)?
  
  public init(
    text: Binding<String>,
    placeholder: String
  ) {
    self._text = text
    self.placeholder = placeholder
  }
  
  public var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(ColorSet.Text.Tertiary)
          .font(FontSet.Body.body2)
      }
      
      TextField("", text: $text)
        .foregroundColor(ColorSet.Text.Primary)
        .font(FontSet.Body.body2)
        .tint(ColorSet.Component.Primary)
        .submitLabel(.search)
        .onSubmit {
          onSubmit?()
        }
    }
  }
}
