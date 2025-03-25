//
//  PIDButtonSize.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public enum PIDButtonSize {
  case large, medium, small
  
  public var cornerRadius: CGFloat {
    switch self {
    case .large: return .Number12
    case .medium: return .Number8
    case .small: return .Number6
    }
  }
  
  public var padding: (vertical: CGFloat, horizonal: CGFloat) {
    switch self {
    case .large: return (.Number12, .Number28)
    case .medium: return (.Number10, .Number20)
    case .small: return (.Number8, .Number12)
    }
  }
  
  public var font: FontInfo {
    switch self {
    case .large: return FontStyle.Label.label1
    case .medium: return FontStyle.Label.label2
    case .small: return FontStyle.Label.label3
    }
  }
}
