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
    textField.borderStyle = style
    return textField
  }
  
  func message(_ message: String?) -> Self {
    var textfield = self
    textfield.message = message
    return textfield
  }
}
