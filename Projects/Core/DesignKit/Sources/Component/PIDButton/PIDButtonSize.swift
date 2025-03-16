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
    case .large: return 10
    case .medium: return 8
    case .small: return 6
    }
  }
  
  public var padding: (vertical: CGFloat, horizonal: CGFloat) {
    switch self {
    case .large: return (12, 28)
    case .medium: return (10, 20)
    case .small: return (8, 12)
    }
  }
  
  public var font: Font {
    switch self {
    case .large: return FontSet.Label.label1
    case .medium: return FontSet.Label.label2
    case .small: return FontSet.Label.label3
    }
  }
}
