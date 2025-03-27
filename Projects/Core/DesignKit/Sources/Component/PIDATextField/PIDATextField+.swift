//
//  PIDATextField+.swift
//  DesignKit
//
//  Created by Jiyeon on 3/20/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension PIDATextField {
  func onSubmit(_ action: @escaping () -> Void) -> Self {
    var textfield = self
    textfield.onSubmit = action
    return textfield
  }
  
  func borderStyle(_ style: BorderStyle) -> Self {
    var textField = self
    if style != .none {
      if textField.isFocused {
        textField.borderStyle = style
      } else {
        textField.borderStyle = .secondary
      }
    }
    return textField
  }
  
  /// TextField 하단의 메세지를 넣을 수 있는 메서드
  func message(_ message: String?) -> Self {
    var textfield = self
    textfield.message = message
    return textfield
  }
}
