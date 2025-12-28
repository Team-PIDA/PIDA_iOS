//
//  IconSize.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum IconSize {
  case extremeLarge, superLarge, extraLarge, large24, large, medium, small
  
  public var dimension: CGFloat {
    switch self {
    case .extremeLarge: return .Number40
    case .superLarge: return .Number32
    case .extraLarge: return .Number28
    case .large24: return .Number24
    case .large: return .Number20
    case .medium: return .Number18
    case .small: return .Number16
    }
  }
}
