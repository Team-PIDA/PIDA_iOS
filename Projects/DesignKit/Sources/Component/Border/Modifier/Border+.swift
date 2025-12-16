//
//  Border+.swift
//  DesignKit
//
//  Created by Jiyeon on 3/22/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI

public extension BorderView {
  func borderColor(_ color: Color) -> Self {
    var border = self
    border.color = color
    return border
  }
}
