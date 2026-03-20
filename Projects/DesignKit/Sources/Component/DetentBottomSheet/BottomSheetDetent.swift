//
//  BottomSheetDetent.swift
//  DesignKit
//
//  Created by Jiyeon on 1/8/26.
//  Copyright © 2026 com.pida.me. All rights reserved.
//

import Foundation
public enum BottomSheetDetent: CaseIterable, Equatable {
  case low
  case medium
  case high
  
  public func visibleHeight(minHeight: CGFloat, screenHeight: CGFloat, mediumRatio: CGFloat = 3.0 / 5.0) -> CGFloat {
    switch self {
    case .low:    return minHeight
    case .medium: return (screenHeight - 64.0) * mediumRatio
    case .high:   return screenHeight
    }
  }
}
