//
//  BorderSize.swift
//  DesignKit
//
//  Created by Jiyeon on 3/22/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public enum BorderSize {
  case short
  case long
  case xlarge
  
  var height: CGFloat {
    switch self {
    case .short, .long:
      return .Number1
    case .xlarge:
      return .Number8
    }
  }
  
}
