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
  
  @FocusState private var internalFocus: Bool
  @Binding var isFocused: Bool
  @State var focused: Bool = true
  
  var borderStyle: BorderStyle = .none
  var onSubmit: (() -> Void)?
  
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
          .fontStyle(FontSet.Body.body2)
      }
      
      TextField("", text: $text)
        .focused($internalFocus)
        .foregroundColor(ColorSet.Text.Primary)
        .fontStyle(FontSet.Body.body2)
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
    .padding(borderStyle != .none ? .Number12 : 0)
    .overlay {
      if borderStyle != .none {
        RoundedRectangle(cornerRadius: .Number10)
          .stroke(borderStyle.color, lineWidth: .Number1)
      }
    }
  }
}


#Preview {
  PIDATextField(text: .constant("하하"), placeholder: "placeholder", isFocused: .constant(false))
    .borderStyle(.accent)
  PIDATextField(text: .constant(""), placeholder: "placeholder", isFocused: .constant(false))
    .borderStyle(.error)
}
