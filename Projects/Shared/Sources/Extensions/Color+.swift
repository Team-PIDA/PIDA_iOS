//
//  Color+.swift
//  Shared
//
//  Created by 조용인
//  Copyright © 2026 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension Color {
  /// hex 값으로 Color 생성
  /// - Parameter hex: 0xRRGGBB 형식의 hex 값
  init(hex: UInt) {
    self.init(
      red: Double((hex >> 16) & 0xFF) / 255.0,
      green: Double((hex >> 8) & 0xFF) / 255.0,
      blue: Double(hex & 0xFF) / 255.0
    )
  }
}
