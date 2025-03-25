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
  @FocusState private var internalFocus: Bool
  
  @Binding var isFocused: Bool
  @State var focused: Bool = true
  public init(
    text: Binding<String>,
    placeholder: String,
    isFocused: Binding<Bool>
  ) {
    self._text = text
    self.placeholder = placeholder
    self._isFocused = isFocused
  }
  
  public var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(ColorSet.Text.Tertiary)
          .fontStyle(FontStyle.Body.body2)
      }
      
      TextField("", text: $text)
        .focused($internalFocus)
        .foregroundColor(ColorSet.Text.Primary)
        .fontStyle(FontStyle.Body.body2)
        .tint(ColorSet.Component.Primary)
        .onSubmit {
          onSubmit?()
        }
        .onChange(of: isFocused) { _, newValue in
          internalFocus = newValue
        }
        .onChange(of: internalFocus) { _, newValue in
          if isFocused != newValue {
            isFocused = newValue
          }
        }
    }
  }
}
