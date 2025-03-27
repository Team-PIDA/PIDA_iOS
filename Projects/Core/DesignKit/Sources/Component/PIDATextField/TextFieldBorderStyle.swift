//
//  TextFieldBorderStyle.swift
//  DesignKit
//
//  Created by Jiyeon on 3/27/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public enum BorderStyle {
  case accent
  case error
  case primary
  case none
  
  var color: Color {
    switch self {
    case .accent:
      ColorSet.Border.Accent
    case .error:
      ColorSet.Border.Error
    case .primary:
      ColorSet.Border.Primary
    case .none:
      Color.clear
    }
  }
}
