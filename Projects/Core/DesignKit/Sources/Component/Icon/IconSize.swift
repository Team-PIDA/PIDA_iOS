//
//  IconSize.swift
//  DesignKit
//
//  Created by 조용인 on 3/16/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum IconSize {
  case superLage, large, medium, small
  
  public var dimension: CGFloat {
    switch self {
    case .superLage: return 32
    case .large: return 20
    case .medium: return 18
    case .small: return 16
    }
  }
}
