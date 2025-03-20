//
//  IconSize.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum IconSize {
  case superLarge, extraLarge, large, medium, small
  
  public var dimension: CGFloat {
    switch self {
    case .superLarge: return .Number32
    case .extraLarge: return .Number28
    case .large: return .Number20
    case .medium: return .Number18
    case .small: return .Number16
    }
  }
}
